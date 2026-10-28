#!/bin/bash
MAVEN_PKGS=$(gh api "/orgs/infosmid-org/packages?package_type=maven" | jq -r '.[] | .name')
for pkg in $MAVEN_PKGS; do
  VERSIONS=$(gh api "/orgs/infosmid-org/packages/maven/$pkg/versions" | jq -r '.[] | .name')
  for version in $VERSIONS; do
    echo "::info Maven Package: $pkg:$version"
  done
done
IMAGES=$(gh api "/orgs/infosmid-org/packages?package_type=container" | jq -r '.[] | .name')
for img in $IMAGES; do
  VERSIONS=$(gh api "/orgs/infosmid-org/packages/container/$img/versions" | jq -r '.[] | select(.metadata.container.tags != null and (.metadata.container.tags | length > 0)) | .metadata.container.tags | .[]')
  for version in $VERSIONS; do
    echo "::info Container: ghcr.io/infosmid-org/$img:$version"
  done
done
