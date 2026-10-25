class Kontext < Formula
  desc "Identity, credentials, and governance for AI agents"
  homepage "https://kontext.security"
  url "https://ghfast.top/https://github.com/kontext-security/kontext/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "7f5146e0a4c88380accaa9f17af5a165a497c2142403b1ca73c8c18074cba51c"
  license "MIT"
  head "https://github.com/kontext-security/kontext.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1b07b0d1c79d9507e40ff241f910da0f208c312cdb64664c336763ca937ca20"
  end

  depends_on "go" => :build
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X github.com/kontext-security/kontext/internal/buildinfo.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kontext"

    generate_completions_from_executable(bin/"kontext", shell_parameter_format: :cobra)
  end

  test do
    assert_match "#{version} (built by #{tap.user})", shell_output("#{bin}/kontext --version")

    settings = shell_output("#{bin}/kontext claude managed-settings template --kontext-binary #{bin}/kontext")
    (testpath/"settings.json").write settings
    assert_match "Claude managed settings valid",
      shell_output("#{bin}/kontext claude managed-settings validate #{testpath}/settings.json " \
                   "--kontext-binary #{bin}/kontext")

    assert_match "managed config not found", shell_output("#{bin}/kontext whoami 2>&1", 1)
  end
end