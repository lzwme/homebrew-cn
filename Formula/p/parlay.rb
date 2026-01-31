class Parlay < Formula
  desc "Enrich SBOMs with data from third party services"
  homepage "https://github.com/snyk/parlay"
  url "https://ghfast.top/https://github.com/snyk/parlay/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "7254db230b23f6d089df3f7f31d9092681707445cfd29fc22007cf2a773c335a"
  license "Apache-2.0"
  head "https://github.com/snyk/parlay.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0092099408325109423825cb6c021a1b30345a5e45ed66967dbbefb8d1e91768"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0092099408325109423825cb6c021a1b30345a5e45ed66967dbbefb8d1e91768"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0092099408325109423825cb6c021a1b30345a5e45ed66967dbbefb8d1e91768"
    sha256 cellar: :any_skip_relocation, sonoma:        "6926910aaf3cd28a3abc63cdfa6738ddd5108ecdd3254514d1a9c8a1ea1cc033"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4721527d028d63cd025e55e13ac0fb363b07a26f3c19a74c7ec4dc8f453d5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63ae80c044d1d761529f68449001b16f6f775b818fe6ae0894b788cce66e90dd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/snyk/parlay/internal/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parlay --version")

    # test sbom data from https://github.com/snyk/parlay/blob/main/README.md?plain=1#L82
    (testpath/"sbom.spdx.json").write <<~JSON
      {
        "spdxVersion": "SPDX-2.3",
        "dataLicense": "CC0-1.0",
        "SPDXID": "SPDXRef-DOCUMENT",
        "name": "Example SPDX Document",
        "documentNamespace": "https://spdx.org/spdxdocs/example-spdx-document",
        "packages": [
          {
            "name": "concat-map",
            "SPDXID": "SPDXRef-7-concat-map-0.0.1",
            "versionInfo": "0.0.1",
            "downloadLocation": "NOASSERTION",
            "copyrightText": "NOASSERTION",
            "externalRefs": [
              {
                "referenceCategory": "PACKAGE-MANAGER",
                "referenceType": "purl",
                "referenceLocator": "pkg:npm/concat-map@0.0.1"
              }
            ]
          }
        ]
      }
    JSON

    # enrich the SBOM with ecosyste.ms data
    enriched_output = shell_output("#{bin}/parlay ecosystems enrich sbom.spdx.json")
    enriched_json = JSON.parse(enriched_output)

    package = enriched_json["packages"].first
    assert_equal "https://github.com/ljharb/concat-map#readme", package["homepage"]
    assert_equal "MIT", package["licenseConcluded"]
    assert_equal "concatenative mapdashery", package["description"]
  end
end