class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv1.48.0.tar.gz"
  sha256 "ea69c5359b72eebb10389cf8ffc1966a66b25d5e7df66ac5349ab91e40d3e32c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eea55fd96a1870bd0e7a3cbc79bde25d8633baf2afc1774c94f28d0068e43494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eea55fd96a1870bd0e7a3cbc79bde25d8633baf2afc1774c94f28d0068e43494"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eea55fd96a1870bd0e7a3cbc79bde25d8633baf2afc1774c94f28d0068e43494"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a58072c220ce71f8d56d37433301ed26b6ab37ddb194e64cacbb8f1152b1f10"
    sha256 cellar: :any_skip_relocation, ventura:       "8a58072c220ce71f8d56d37433301ed26b6ab37ddb194e64cacbb8f1152b1f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a46f9a48a07ae086cf253394cc61f6476edbe5bc0206365af2cc7e7d71c42306"
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