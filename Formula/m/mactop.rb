class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://ghfast.top/https://github.com/metaspartan/mactop/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "753c9d2a47b0cbd92463b579d743647a23d96e1c1805f9e729ad14473b786e9f"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c4b92264365b56358fffe955a35827d35d8ddc199302ec5f86352fd414c0693"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37d163633249d6025eaae2a80bbcd3ebd5607e8ad6d50957349deed55be041f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d0e9f1e0e4e4b6765e8ecd8831158e19196706fde52b2efddec23881a553366"
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