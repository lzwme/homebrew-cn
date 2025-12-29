class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.15.5.tar.gz"
  sha256 "5b9bfed6bf02d1ba9904a667af0930b871c40e5aed37e1530afe1d22e8e93d67"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "377dbf9deb0bdd4a78500faf18c0a56af263cd5fed5eda2d332dcd0de28eddab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb61a3028f37b523cbd184479aacb3e468cdf64a72be0cfd59b22007dc3c427e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d4741ce66950db2fa8a2fd61687375c3eea2a86ebe61715e195d97fc1ed4a8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "21ec40e9778cb149d54b03d97865d3d1c5f95962e8ff1e2f1c73eddd5f626af8"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end