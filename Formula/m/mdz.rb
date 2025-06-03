class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv2.2.1.tar.gz"
  sha256 "f74b30f2d62e0ab002c104b075ffda8a9574a8597a73abc31bfa7b7e264d3517"
  license "Apache-2.0"
  head "https:github.comLerianStudiomidaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8481a1226d70274630b2fc511f04466de21ef9e0b5fe5e0325e982ee28df9472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c2d452a5f38ae66427ca0162583c9e43098ab3952f08882ec6185f5d9b86b72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "165ad093dcf52844256dd5177031807568c38a731a9f56ca45090e045f05be6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e3d12909ba110ebf4c7b5a045942f2cef46d9171f46686a2cda165428ac63a3"
    sha256 cellar: :any_skip_relocation, ventura:       "9390a7e76047c2e9b36496cc58278c1d26b20a511aca00b2e49cb6acb9652473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f286d010550d44bdd61d3e858e1e8f9b0f77368a65a94969f30bcfcdb0bf1de4"
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