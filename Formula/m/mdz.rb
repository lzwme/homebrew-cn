class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.4.6.tar.gz"
  sha256 "80053ee07638f70d0817b160bfde87d0ae3ac1bb7efc2e0543778d0a3e00c81f"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e08548be55a59250893f377563edceb41f16b51ef3426181cb31aa56852bef9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8c7f648c96d7c544027ca9ef7e5d7815207b9e3e3bd008d50e8088c89cc86e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2e4e0810bfa327f6ccfcbbda89800d9c1397f40a980258d8e61062a912cbf56"
    sha256 cellar: :any_skip_relocation, sonoma:        "abb6096bce1bea4e888389263b0c7b211d8ef1bffd2e4239260eb8d709f3f919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "330e6b1f1517162e124728d4153cc2a2a5d978027358ddcfa108abdbc7df3cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e23018568a378074dcb7df0504d2030a1c9580ea74da3fdda8b6988a6e28c0"
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