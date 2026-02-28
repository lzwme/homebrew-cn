class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.28.0.tar.gz"
  sha256 "349b2e8c3ef1f8417ea8b94ab9b2f19c0dc167d4dc464afc67ca305e1eeaf909"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77cc552ba14b1307ba7611ed6544e6d38f2af4dfba4f1eeff0cc38b038e48f63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8860ce26c9ade6ee9a590f21051fc0cad33a68b2f34f5ebd8eb37e5b4daabedd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "707c3257bb28a47ff304f86cd3fa18e7f16e830565c6d7173f6370019f0ae311"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ba6c4757e058cb2f118f5096c311253a07fa1e43a03e4f0b40473c169d1a33c"
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