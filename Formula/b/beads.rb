class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/gastownhall/beads"
  url "https://ghfast.top/https://github.com/gastownhall/beads/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "03ad2d43a97c75248ecfae28cad6789af506861c18568399c6e1432b02c1fe48"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gastownhall/beads.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "415c05e28b103c84a92c3a4409da83910736f45f290ec8ee59e559cda890d9c0"
    sha256 cellar: :any, arm64_sequoia: "a8c7f8b5756370f84e4a4fdd0c223dd0a1689e29ab23c6efa34581ac50896aac"
    sha256 cellar: :any, arm64_sonoma:  "65c73e0550284da9745313be76e676404351436c5e54f6f029a4ef4c7c62708e"
    sha256 cellar: :any, sonoma:        "8c3b8a2eff85c61cd782f5bad7dfa0e926609005158c71aaffe3d402ff6dd573"
    sha256 cellar: :any, arm64_linux:   "b3ea0979b9a09a4783f3a3281ceb49567b17d6f26987e97f44e07de8e7a139ae"
    sha256 cellar: :any, x86_64_linux:  "84fe105e2d2c52b06236c2e67108a6f9d7b921a683d63726d920fbe195d84b55"
  end

  depends_on "go" => :build
  depends_on "dolt"
  depends_on "icu4c@78"

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