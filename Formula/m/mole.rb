class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.24.0.tar.gz"
  sha256 "95ec25b2a4f63c3c10cd1fafe25e6520dde57faa833a58859e40b3636f44c3d1"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "299430ad9ab249b5aad056aef51a476ba047322466aeed1f4e623019e697ebb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74f1482940a5c602e538cc2b5140401256f537b8c9d2c247b9cb2127b70761b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7188a417a30f0fcc97bc7ded5da24ddd8c62e6b20f8e4ede51571a8bc0b7671b"
    sha256 cellar: :any_skip_relocation, sonoma:        "702c4649bae942c6f0485ac92508f0fb8bd090a43cffdb70ce8bd5e84348429a"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    %w[analyze status].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: buildpath/"bin/#{cmd}-go"), "./cmd/#{cmd}"
    end

    inreplace "mole", 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"',
                      "SCRIPT_DIR='#{libexec}'"
    libexec.install "bin", "lib"
    bin.install "mole"
    bin.install_symlink bin/"mole" => "mo"
    generate_completions_from_executable(bin/"mole", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end