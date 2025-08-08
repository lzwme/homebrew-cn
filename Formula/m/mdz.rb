class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "fa0ddc746558631cc44a3a2d820ccd14fed7101609b453aba948bf20ced180c1"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03b14596a1e898addba7e2728244ad8fb239221b8766ea44338bd4004fa7fe47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9cb90d49395e670e489d87748ae3ef580ae5c9fd415e01def8fd8ed3414ec95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1401c6d2d8886e78746d17878974b9b7a29583080dbc1b86790ffa74ec5f389a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf0a68814238e187dd5593e8a4ef8c0622aa66b7fe0b954a4c7890635dc9a9d8"
    sha256 cellar: :any_skip_relocation, ventura:       "71910af8c5012a7308f8d8249da95d8a688c5f7b4ba1ea9eb54da60e606bd508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "196053972b01d22d4e4e47d7902f1331f9558706b5348170d9b7bd1836c92cda"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/LerianStudio/midaz/v3/components/mdz/pkg/environment.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./components/mdz"

    generate_completions_from_executable(bin/"mdz", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "Mdz CLI #{version}", shell_output("#{bin}/mdz --version")

    client_id = "9670e0ca55a29a466d31"
    client_secret = "dd03f916cacf4a98c6a413d9c38ba102dce436a9"
    url_api_auth = "http://127.0.0.1:8080"
    url_api_ledger = "http://127.0.0.1:3000"

    output = shell_output("#{bin}/mdz configure --client-id #{client_id} " \
                          "--client-secret #{client_secret} --url-api-auth #{url_api_auth} " \
                          "--url-api-ledger #{url_api_ledger}")

    assert_match "client-id:       9670e0ca55a29a466d31", output
    assert_match "client-secret:   dd03f916cacf4a98c6a413d9c38ba102dce436a9", output
    assert_match "url-api-auth:    http://127.0.0.1:8080", output
    assert_match "url-api-ledger:  http://127.0.0.1:3000", output
  end
end