"""Data model package for ofp-datamodel."""

from pathlib import Path
from .ofp_datamodel import *  # noqa: F403

THIS_PATH = Path(__file__).parent

SCHEMA_DIRECTORY = THIS_PATH.parent / "schema"
MAIN_SCHEMA_PATH = SCHEMA_DIRECTORY / "ofp_datamodel.yaml"
