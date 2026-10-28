class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/xguot/difi"
  url "https://ghfast.top/https://github.com/xguot/difi/archive/refs/tags/v0.2.32.tar.gz"
  sha256 "1473f63d985b49c076605d6959e60ae2134490b5b9d7936aec6db936abfd00b1"
  license "MIT"
  head "https://github.com/xguot/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e232455a9f7e8f55c8d98c0fee85a2fc41a94b6a646c9d7f6f33626ff7f934f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e232455a9f7e8f55c8d98c0fee85a2fc41a94b6a646c9d7f6f33626ff7f934f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e232455a9f7e8f55c8d98c0fee85a2fc41a94b6a646c9d7f6f33626ff7f934f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "01a41019b832fa560a8d02465917e68e70af584c8e7f23693c59d45a2f96ef98"
    sha256 cellar: :any,                 x86_64_linux:      "b6d4afc8182995a17b58d3dafc064c1a6721279ab5fcf58ba30c73988e07f9be"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/difi"
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