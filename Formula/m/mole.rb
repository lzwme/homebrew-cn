class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.19.0.tar.gz"
  sha256 "9a211c503f9dc530f4fbc0447bcae4b078d8f37aef45b74b30698e57215bc2d4"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70a5204e5fab6eb73d87f2edbbdec76b79934bbb0fd2c9bb9124f475af5dcfc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "672b2a86447cfcd43b002a155b2847b18a1e16bd19ffb74e7ea1b3957eca90e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e81248ee5ef68c2a9745ddd40caad78465630aa7baba3c8ddfb839ed28a31e64"
    sha256 cellar: :any_skip_relocation, sonoma:        "4870d27d9253271f96bf689e2f4279088aa7bd6e6ca1ed0dec8641cedf179c23"
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