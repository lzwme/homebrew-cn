class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.4.7.tar.gz"
  sha256 "d03a4af26f0f1727fc8a835194b747e20754466995efc94fb02e7cd5f24f1b67"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e651d6352ecd5661ad278bb9587f2cb551aa8aecd6a69775be5f87d4a56736a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7c436dacbfba564ca6dd390bb667ff9162f341b136db66eff71d3280d5292b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60d3f1ae7125eef0563ebdd7a2633030931a21c881e3eea38f4112d3d8216d4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff923d9e7e19fe78dcd0b35116b82615185cd2264f46debc8bac47cbc32e2479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6704bc0532637b1c8487700b0520467c624ad4f314d5fe7f480ccc1ba5f435c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "927d3e625169f2db2a994e83874e434ac4de3b0a9551b35a61c56c6e24e5ca9a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/LerianStudio/midaz/v#{version.major}/components/mdz/pkg/environment.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./components/mdz"

    generate_completions_from_executable(bin/"mdz", shell_parameter_format: :cobra)
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