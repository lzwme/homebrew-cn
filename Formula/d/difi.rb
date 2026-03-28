class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/oug-t/difi"
  url "https://ghfast.top/https://github.com/oug-t/difi/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "e89ad09a3fa1d1eb835c4f61d7af99b103e4d8e562b7e7c6c8d1ea79b3c51bfa"
  license "MIT"
  head "https://github.com/oug-t/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b449c30c1c1296a740b5caab98203ac59dc92abbc7b5030fa2afc1cadb809d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b449c30c1c1296a740b5caab98203ac59dc92abbc7b5030fa2afc1cadb809d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b449c30c1c1296a740b5caab98203ac59dc92abbc7b5030fa2afc1cadb809d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df734dbe68e88e3002627da68faf68a105b11d79bc606104a41be78c68e0549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb1b4a033c2f93b9355dc3b3344a0c314846588cc65db80eaf17721192f3371a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a5a8834f0130c28a4f412cde3067d705e1eceafd0f7346e150d45ee016e5874"
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