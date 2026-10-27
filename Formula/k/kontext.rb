class Kontext < Formula
  desc "Identity, credentials, and governance for AI agents"
  homepage "https://kontext.security"
  url "https://ghfast.top/https://github.com/kontext-security/kontext/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "5c84db3413284d40155249f6375466a8e9c9cf53d67fe01f2ffe664bf5d7466e"
  license "MIT"
  head "https://github.com/kontext-security/kontext.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3fb28cc9b4cfe2be78fefbf59bf3b389b9df9f9692e5e278293feb54f2aeecd"
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