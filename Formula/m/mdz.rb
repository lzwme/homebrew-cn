class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv1.31.0.tar.gz"
  sha256 "16b0e877091c1ef6fc466e52c4281a9407081459264f3c8bb7917699687224fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f42b76a3ce6643e019ab0cbee5fa16ac084bf2e4c060af49334ff0979f310bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f42b76a3ce6643e019ab0cbee5fa16ac084bf2e4c060af49334ff0979f310bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f42b76a3ce6643e019ab0cbee5fa16ac084bf2e4c060af49334ff0979f310bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0573efb28c5d61e70a552afcd7b4fc9f8d9bc55ef8e4c8c5f44c13b3ed85352"
    sha256 cellar: :any_skip_relocation, ventura:       "b0573efb28c5d61e70a552afcd7b4fc9f8d9bc55ef8e4c8c5f44c13b3ed85352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ea6fb65223a662e92bedba94a31dcca936cc7e7f408279aae005d0e9a06c3d9"
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