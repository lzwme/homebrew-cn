class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "f4d8c4929f42267160cd424f7d35fb0a3a14a69cc942252b553534f6f2ab852e"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0014f691240ed9203de42c1d1eeaf4d1cfbbb881266f5bb587f31a22ac793b52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3060dcea6908761e7d483a0fd0314bf2d8c25049eba3b5f22b6c094446547e72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d363bbdb941f169307762850fabf9c8bfd128e1ca39f62a875ccc8bd403e28be"
    sha256 cellar: :any_skip_relocation, sonoma:        "61adb2fd45ba4e3dbbf323f3590c8a415f5c1cb399f87e32f3b5a6ed32858c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e77ba8c0d3b146fbd43ae0aff94ffc3c742ff38d167910d547db8dc95146cb3"
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