class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://ghproxy.com/https://github.com/projectdiscovery/httpx/archive/v1.2.8.tar.gz"
  sha256 "02e4f6ae1a3f962771fcfeebc7b51fadcaa7eec799069f8e5d845ba69512ff04"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b123cb269724904eaee572dfece11f3d50b07633927b0b38b31c92aa3ef7a57e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c25c849c3a0bfd6aee1863cdd732d8132d3505c93682bd954ce4f1f30ce3593b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a08ef18cee460f51112943ecaaefb4f10a48d9adbf8bada60ed1ad8861afbd8"
    sha256 cellar: :any_skip_relocation, ventura:        "a45ef4d271e654bd27d68fec2f274321b681c7d13b49c92d61ab074c8ebe4709"
    sha256 cellar: :any_skip_relocation, monterey:       "76fe9a36cfeff8dd109e6178817415d736e86db4629dd895625e56ecf8d0cbe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b9374f8643e1bf124f91b8c7cc12bec0a435790d64e0193553fed0e3eef45ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c464be8f33cab052482c3249be76c8b8f5482602a0134f8aa7173ae66f8d795"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end