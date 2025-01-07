class Parlay < Formula
  desc "Enrich SBOMs with data from third party services"
  homepage "https:github.comsnykparlay"
  url "https:github.comsnykparlayarchiverefstagsv0.6.5.tar.gz"
  sha256 "5f9a8a45b11b44bd0f416b2f6dd60fd7c3ef2bfb5304c8e11270b4a64f0e6463"
  license "Apache-2.0"
  head "https:github.comsnykparlay.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf040aa88904a9f362500cfa1d1df6a7705c49c686acef2498228456274f806d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf040aa88904a9f362500cfa1d1df6a7705c49c686acef2498228456274f806d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf040aa88904a9f362500cfa1d1df6a7705c49c686acef2498228456274f806d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ce1332d3c30003ac9820c251912913fc66c162c6f0f04cd11fa6d1c65c05755"
    sha256 cellar: :any_skip_relocation, ventura:       "5ce1332d3c30003ac9820c251912913fc66c162c6f0f04cd11fa6d1c65c05755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1399055c15e874dc43faae8de44286b549acf9f4a8cf0d781ef9adc9c9f92774"
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