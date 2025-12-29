class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://ghfast.top/https://github.com/metaspartan/mactop/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "de3f25f38497195476d479eb03f6e75d7612e6257ce1e069f6e13cb956bccea9"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "996b06047468fc8e23ad3907e474f3b979e6a16c4c12d2deadc2b91a1a65fa31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "874cb708dde464fb62d42a480d88cd3248cab1d825c8226ae4a28fbf3f3494b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f153a5b48e85f2ee1ceeb7f2ef4235b73ce905f86e4b63b4693a7a72002b7e57"
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