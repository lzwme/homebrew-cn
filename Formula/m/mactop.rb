class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://ghfast.top/https://github.com/metaspartan/mactop/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "af5abc8dff539da7c1d8771327307bd1fac12d4cf768f6696826a49c493a2abf"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7164a9b08a0e47255b8ef0d70fec657bc145c31fe9a0907db640754c079523c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf1bc7e8bcbb898715f2b6271fd3a4fef8b53ff468b20e7f8a7730737be554db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88a0714bea9d388f4a76aefc6bf238d72b6a1a5d7b7c217e7b59ee105406cd7d"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end