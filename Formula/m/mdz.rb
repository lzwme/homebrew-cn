class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv1.47.0.tar.gz"
  sha256 "aabff4caa47fc5fb08359dbe18d48c278b2b20c4d440835a7f14a5868d3071ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5d94c4d2cdb46db317be91685c7bec37968bda579909b26f3aac5668c3431b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af5d94c4d2cdb46db317be91685c7bec37968bda579909b26f3aac5668c3431b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af5d94c4d2cdb46db317be91685c7bec37968bda579909b26f3aac5668c3431b"
    sha256 cellar: :any_skip_relocation, sonoma:        "091511b654dd0744bf512a7e37391011e24c54bbf37cc68fe89bba01e0dffa6f"
    sha256 cellar: :any_skip_relocation, ventura:       "091511b654dd0744bf512a7e37391011e24c54bbf37cc68fe89bba01e0dffa6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27fafc7cb121a8c3813ce4bb2e6e4aeade1384e02b55e10c6029374b75f46267"
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