class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv1.38.1.tar.gz"
  sha256 "f5c57fa8495359ce7b52360578be72ec5a029eb7fe5a1d812b6d52f5c6f36b4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f071903331d6dcee4ff8ae8faf866f104584b4cfb433d643af04ca4036c91d38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f071903331d6dcee4ff8ae8faf866f104584b4cfb433d643af04ca4036c91d38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f071903331d6dcee4ff8ae8faf866f104584b4cfb433d643af04ca4036c91d38"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a78f71f9b430a97ee082d09a37da7437aef5fa339969587ffef65645dfc84a2"
    sha256 cellar: :any_skip_relocation, ventura:       "6a78f71f9b430a97ee082d09a37da7437aef5fa339969587ffef65645dfc84a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f09e8f47bfca27539527bcc5b26f83b063b4a848dd92d6d537b52a8e072be59"
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