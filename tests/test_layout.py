"""Deterministic layout checks for SynapsCode v1 (no network, no secrets)."""
from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class SynapsCodeLayoutTests(unittest.TestCase):
    def test_required_paths_exist(self) -> None:
        required = [
            ROOT / "README.md",
            ROOT / "NOTICE",
            ROOT / "docs" / "00-synteza-rady.md",
            ROOT / "docs" / "AUTH.md",
            ROOT / "docs" / "PRODUCT.md",
            ROOT / "profile" / "opencode.json",
            ROOT / "profile" / "tui.json",
            ROOT / "profile" / "themes" / "synaptivo.json",
            ROOT / "skills" / "maker-reviewer-lite" / "SKILL.md",
            ROOT / "skills" / "operations-playbook" / "SKILL.md",
            ROOT / "install" / "Install-SynapsCode.ps1",
            ROOT / "install" / "opencode-pin.json",
            ROOT / "branding" / "logo-sygnet.png",
            ROOT / "website" / "download-section.md",
            ROOT / "website" / "INTEGRATION.md",
            ROOT / "experiments" / "dsh-bakeoff.md",
            ROOT / "experiments" / "Run-DshBakeoff.ps1",
            ROOT / "docs" / "ACCEPTANCE-v1.md",
        ]
        missing = [str(p.relative_to(ROOT)) for p in required if not p.is_file()]
        self.assertEqual(missing, [], f"missing files: {missing}")

    def test_theme_is_synaptivo_brand(self) -> None:
        theme = json.loads((ROOT / "profile" / "themes" / "synaptivo.json").read_text(encoding="utf-8"))
        defs = theme["defs"]
        self.assertEqual(defs["ink"], "#0e0920")
        self.assertEqual(defs["brandIndigo"], "#7364df")
        self.assertEqual(defs["brandViolet"], "#ac38df")

    def test_tui_selects_synaptivo_theme(self) -> None:
        tui = json.loads((ROOT / "profile" / "tui.json").read_text(encoding="utf-8"))
        self.assertEqual(tui["theme"], "synaptivo")

    def test_opencode_config_has_openrouter(self) -> None:
        cfg = json.loads((ROOT / "profile" / "opencode.json").read_text(encoding="utf-8"))
        self.assertIn("openrouter", cfg["provider"])

    def test_pin_is_upstream_tag(self) -> None:
        pin = json.loads((ROOT / "install" / "opencode-pin.json").read_text(encoding="utf-8"))
        self.assertTrue(str(pin["tag"]).startswith("v"))
        self.assertIn("anomalyco/opencode", pin["url"])

    def test_no_secrets_in_tree(self) -> None:
        # Flag likely secret material, not documentation of env var names.
        import re

        patterns = [
            re.compile(r"BEGIN PRIVATE KEY"),
            re.compile(r"sk-or-[a-zA-Z0-9]{16,}"),
            re.compile(r"(?i)api[_-]?key\s*=\s*['\"][^'\"]+['\"]"),
        ]
        text_files = list(ROOT.rglob("*.md")) + list(ROOT.rglob("*.json")) + list(ROOT.rglob("*.ps1"))
        offenders: list[str] = []
        for path in text_files:
            if "_graph" in path.parts or ".git" in path.parts:
                continue
            data = path.read_text(encoding="utf-8", errors="ignore")
            for pat in patterns:
                if pat.search(data):
                    offenders.append(f"{path.relative_to(ROOT)}:{pat.pattern}")
        self.assertEqual(offenders, [])

    def test_auth_doc_forbids_seat_resale(self) -> None:
        auth = (ROOT / "docs" / "AUTH.md").read_text(encoding="utf-8").lower()
        self.assertIn("per-user", auth)
        self.assertIn("openrouter", auth)
        self.assertTrue("does not" in auth or "nie" in auth or "non-goals" in auth)

    def test_installer_refuses_secret_language(self) -> None:
        ps1 = (ROOT / "install" / "Install-SynapsCode.ps1").read_text(encoding="utf-8")
        self.assertIn("DryRun", ps1)
        self.assertIn("Assert-NoSecretArgs", ps1)
        self.assertIn("synapscode-install-receipt.json", ps1)
        self.assertIn("Never writes API keys", ps1)

    def test_no_upstream_source_checkout(self) -> None:
        forbidden = ["packages/opencode", "deepseek-harness/packages", "anomalyco"]
        for path in ROOT.rglob("*"):
            if ".git" in path.parts or "_graph" in path.parts:
                continue
            rel = str(path.relative_to(ROOT)).replace("\\", "/")
            for bad in forbidden:
                self.assertNotIn(bad, rel)

    def test_bakeoff_runner_mentions_both_arms(self) -> None:
        text = (ROOT / "experiments" / "Run-DshBakeoff.ps1").read_text(encoding="utf-8")
        self.assertIn("A_opencode_synapscode", text)
        self.assertIn("B_deepseek_harness", text)
        self.assertIn("secrets_accepted", text)


if __name__ == "__main__":
    unittest.main()
