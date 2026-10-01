class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/gastownhall/beads"
  url "https://ghfast.top/https://github.com/gastownhall/beads/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "2bef11b5c87c97f93c736e79ff27e9cae574d37da37f8fc7e24b6940c8058b48"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6a187c06f703e28ba5a467b22560cff3d7635d2a9fcdd61945e2a62262f38184"
    sha256 cellar: :any, arm64_tahoe:       "7c20d93ba428a5e8b8de5310955d1ee928c86053183bafec8a9e1b8342ac7d3e"
    sha256 cellar: :any, arm64_sequoia:     "4cd77edf1d7a65b4042244c1be3a85c76affcb652011c7dc2c74a744cac30cb6"
    sha256 cellar: :any, arm64_linux:       "b2ea454b97fc1b11629f2596ee53bf6336743f5ecbd38d90d392d22b643df9a9"
    sha256 cellar: :any, x86_64_linux:      "24e60a6a40ff1304d109bf425dd7c8e83c2ae8a42ce3f62ba350c3f81fc031f0"
  end

  depends_on "go" => :build
  depends_on "dolt"
  depends_on "icu4c@78"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -X main.Version=#{version}
      -X main.Build=#{tap.user}
      -X main.Branch=#{build.head? ? "HEAD" : "v#{version}"}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/bd"
    bin.install_symlink "beads" => "bd"

    generate_completions_from_executable(bin/"bd", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system bin/"bd", "init", "--prefix", "homebrew-beads", "--non-interactive", "--stealth"
    system bin/"bd", "setup", "claude"
    assert_path_exists testpath/"CLAUDE.md"
    assert_path_exists testpath/".beads/config.yaml"

    output = shell_output("#{bin}/bd --db #{testpath}/.beads/dolt info")
    assert_match "Beads Database Information", output
    assert_match "Issue Count: 0", output
  end
end