class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/oug-t/difi"
  url "https://ghfast.top/https://github.com/oug-t/difi/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "9a67cae9514d531f5597f9b342f78f42288cf85cbaed608d22334ab82291b084"
  license "MIT"
  head "https://github.com/oug-t/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f53cb691f7cd8836bfd7ecae85f5ddedfd32ccc607f817df9abe0b2645993489"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f53cb691f7cd8836bfd7ecae85f5ddedfd32ccc607f817df9abe0b2645993489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f53cb691f7cd8836bfd7ecae85f5ddedfd32ccc607f817df9abe0b2645993489"
    sha256 cellar: :any_skip_relocation, sonoma:        "34e011c5ae368ff7c8176d1277cb455f7b97268770500a0d37d747429bf8604f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfac7e950d08f68b84810ada260a3e258a6ff4f2e338735a9595eb9aca71f6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46b7e0e8d2e0aa7c166edc7ab57839ea2de5def417c31768dc1827422a2046fd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/difi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/difi -version")

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test"

    (testpath/"file.txt").write("one")
    system "git", "add", "file.txt"
    system "git", "commit", "-m", "init"

    File.write(testpath/"file.txt", "two")
    system "git", "commit", "-am", "change"

    output = shell_output("#{bin}/difi --plain HEAD~1")
    assert_match "file.txt", output
  end
end