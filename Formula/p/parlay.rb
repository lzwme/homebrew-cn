class Parlay < Formula
  desc "Enrich SBOMs with data from third party services"
  homepage "https:github.comsnykparlay"
  url "https:github.comsnykparlayarchiverefstagsv0.6.4.tar.gz"
  sha256 "b378e31a7f7ba7ac8373febf26e8d4796e724a1ab57844d928906ff3e25858f4"
  license "Apache-2.0"
  head "https:github.comsnykparlay.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "412eb05356a186c28db0b8eabf85237eae42a52879d13d7ac4ac7543e1e485e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "412eb05356a186c28db0b8eabf85237eae42a52879d13d7ac4ac7543e1e485e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "412eb05356a186c28db0b8eabf85237eae42a52879d13d7ac4ac7543e1e485e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "42e5d0385abe716181c905367121ad2f163c4c4122f894c0ec66784713a365e5"
    sha256 cellar: :any_skip_relocation, ventura:       "42e5d0385abe716181c905367121ad2f163c4c4122f894c0ec66784713a365e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77b459d62aa512a32cb99f6e0f7eace1b8cf1d6ab187f54a641840507d6584eb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsnykparlayinternalcommands.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}parlay --version")

    # test sbom data from https:github.comsnykparlayblobmainREADME.md?plain=1#L82
    (testpath"sbom.spdx.json").write <<~JSON
      {
        "spdxVersion": "SPDX-2.3",
        "dataLicense": "CC0-1.0",
        "SPDXID": "SPDXRef-DOCUMENT",
        "name": "Example SPDX Document",
        "documentNamespace": "https:spdx.orgspdxdocsexample-spdx-document",
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
                "referenceLocator": "pkg:npmconcat-map@0.0.1"
              }
            ]
          }
        ]
      }
    JSON

    # enrich the SBOM with ecosyste.ms data
    enriched_output = shell_output("#{bin}parlay ecosystems enrich sbom.spdx.json")
    enriched_json = JSON.parse(enriched_output)

    package = enriched_json["packages"].first
    assert_equal "https:github.comljharbconcat-map", package["homepage"]
    assert_equal "MIT", package["licenseConcluded"]
    assert_equal "concatenative mapdashery", package["description"]
  end
end