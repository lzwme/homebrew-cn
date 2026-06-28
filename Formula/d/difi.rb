class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/xguot/difi"
  url "https://ghfast.top/https://github.com/xguot/difi/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "5779be0a49cf48563ee7dbef94156d1cebe2d7b99c0bce95df1bce085b641157"
  license "MIT"
  head "https://github.com/xguot/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be7cb2c7167aa603f279ac92298f27ae30412790ff04cf960abda0d356e1442c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be7cb2c7167aa603f279ac92298f27ae30412790ff04cf960abda0d356e1442c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7cb2c7167aa603f279ac92298f27ae30412790ff04cf960abda0d356e1442c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4da255b70705e0746ee24d236dcd3441a1741406ce0401b1d9591a713bc6d3be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4694dbe43138ffaaa36f240c61cd880975be8502c6a9ec765279a826d0bfb71d"
    sha256 cellar: :any,                 x86_64_linux:  "cbb2168d8a33dad8bf9e53c47407932915975ca73d3dc43f0f57b309c8e8584e"
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