class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://ghproxy.com/https://github.com/mattn/goreman/archive/v0.3.14.tar.gz"
  sha256 "1d1c24abf32baee8f52865cb8e43056a4b0a30e646b282b17e117b6fcc6cce3d"
  license "MIT"
  head "https://github.com/mattn/goreman.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0101f4aecbab5b055aabb25a83844d9ff926b85bdfb63bcdc6d9c06cfe0e019b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0101f4aecbab5b055aabb25a83844d9ff926b85bdfb63bcdc6d9c06cfe0e019b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0101f4aecbab5b055aabb25a83844d9ff926b85bdfb63bcdc6d9c06cfe0e019b"
    sha256 cellar: :any_skip_relocation, ventura:        "3e7417e7500d3665d3cc93bf7425bf3cdbb30f7cc9c42860fc8434e04197a418"
    sha256 cellar: :any_skip_relocation, monterey:       "3e7417e7500d3665d3cc93bf7425bf3cdbb30f7cc9c42860fc8434e04197a418"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e7417e7500d3665d3cc93bf7425bf3cdbb30f7cc9c42860fc8434e04197a418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9915210e3942623384549047d25b163326ca633ef451c1237529e59df05ecff2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end