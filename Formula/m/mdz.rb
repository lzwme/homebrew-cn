class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv1.51.0.tar.gz"
  sha256 "fea0143f5f1693cd51a4b8f2263cd92f1ea4d8bc003772697133c908dc6d501c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d660d433746c1075fc8cb8802819fe35747561b06c8d01b3bca47a85c649746"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bf7393d0dbf7128029385de29a665afea1bfe362b6fb1ef269f9d262f15b010"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0c4ab5277053bf28b9909ba4bc881ff110ac4f09296a4b49a2b77fc7051f7c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e7e1a2193eb452fde70cedb87d78cf07b21e713eb009803e43f2979a923041f"
    sha256 cellar: :any_skip_relocation, ventura:       "67c3409fed8dd4f8e18008d6ac72d68c5064c8fec3429a18bd68d7c2c46421cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186b273ee33b3f596b363642c9065ae0db6cd0c1e7a286b7c82bae6de775e146"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comLerianStudiomidazcomponentsmdzpkgenvironment.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".componentsmdz"
  end

  test do
    assert_match "Mdz CLI #{version}", shell_output("#{bin}mdz --version")

    client_id = "9670e0ca55a29a466d31"
    client_secret = "dd03f916cacf4a98c6a413d9c38ba102dce436a9"
    url_api_auth = "http:127.0.0.1:8080"
    url_api_ledger = "http:127.0.0.1:3000"

    output = shell_output("#{bin}mdz configure --client-id #{client_id} " \
                          "--client-secret #{client_secret} --url-api-auth #{url_api_auth} " \
                          "--url-api-ledger #{url_api_ledger}")

    assert_match "client-id:       9670e0ca55a29a466d31", output
    assert_match "client-secret:   dd03f916cacf4a98c6a413d9c38ba102dce436a9", output
    assert_match "url-api-auth:    http:127.0.0.1:8080", output
    assert_match "url-api-ledger:  http:127.0.0.1:3000", output
  end
end