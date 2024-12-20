class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv1.36.0.tar.gz"
  sha256 "58b6a895252bb621559ddf483523658788ab67b6443e07a64c0b81dbaafcc205"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31940940cbbed2f838fa7ec1178fc3a2ba6529882e95307c2714ee257ddf9323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31940940cbbed2f838fa7ec1178fc3a2ba6529882e95307c2714ee257ddf9323"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31940940cbbed2f838fa7ec1178fc3a2ba6529882e95307c2714ee257ddf9323"
    sha256 cellar: :any_skip_relocation, sonoma:        "d46afab61844fb12f6785a915046967cbb626f80f41730f40dbd01489b4fb561"
    sha256 cellar: :any_skip_relocation, ventura:       "d46afab61844fb12f6785a915046967cbb626f80f41730f40dbd01489b4fb561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e49612d203c3cfe8e21b5cc134c8316ded68d9aa5f80d31e7bfffa9b2c3bd00a"
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