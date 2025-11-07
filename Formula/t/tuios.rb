class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "dbe683cd8c3758a613e9d871a8ea9321c6f86bfe4cd6ba44aef8cca6cfe4e2b8"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47193836706a57a06e3f2c7a9c51ad9d5e410938bc6cd6c635431536c9db6979"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2942ee844d88826192da49b9883d90803bef831cb97fff4ebcf2d364b546083c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70011e72d2965f95e7cdc7ebd84fb5b3448ea27e84abc9d0fab9f3463680fbbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4db9dfcd8d1e54e0f69f231e5296d5672c577728f4f9ed96dff031943b34a815"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40629751a3e69c732d82d3eed1a61a19475285c019b585dfeb5405caf15ae21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "205e4e5672bd100afe23b27bfbab1e78a8b66a24a1f52069792f2e9c2a2b3f8b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end