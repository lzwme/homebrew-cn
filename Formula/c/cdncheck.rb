class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.44.tar.gz"
  sha256 "9113c63e3689e77e1812b0754fffd8917bc82882a773b37c7e9529424d61f8a7"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "980f31e0bff66a5de844ff7b3c7a0a66d0e0acfb2885438df46c74360441fbaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e8a207572eb55c91abf89995833f2d709d758507f9513f959a77383df85fd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab1ba01f6922ab8f2d05e2e8f447d82fd1357f2f7d6757c3bfccb8c5053635e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c101947ad7783053f4a3e4cd845ebc501f3ac15c1a2be35256fe22236beb055a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2061beb75cc07bd159546b54ab22a6dd247fc15f369e927afef49419966165fe"
    sha256 cellar: :any,                 x86_64_linux:  "41f4a4196e8c78dc10539b01e7476c8a467ce3cc93d8441ba538c390d25c2bf3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end