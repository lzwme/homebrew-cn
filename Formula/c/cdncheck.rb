class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.48.tar.gz"
  sha256 "fde4821501774a9768721525823bdc451c13ee23e99b3f70e3ca64b661e1e35f"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66ccf93a8db30a9f4b6a2f76126ba650cf99258e34fcf2756ad8effcb35183b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "038525e784ef5badd9c5c8002919e7cfabb71421a5340fd63467191578f06d63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1da0d43a174676970471aac69c6a62c3deeb60b1de82ac4fcb58299e9b8c893f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b544d31e64247c941ff1b2cabe87914a55a844f75625cbeebb0a3874ea24940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b39a13e71a6bdbea6efc5ef08da75034e375c858d174c273d6920d645720eb5a"
    sha256 cellar: :any,                 x86_64_linux:  "376ac4049581b5f9066c82aee9d7dfa30c8f2144bd4878d315f78e6376608770"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end