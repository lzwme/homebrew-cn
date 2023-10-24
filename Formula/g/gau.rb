class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://ghproxy.com/https://github.com/lc/gau/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "b027a6c0edcd5045303d1a5f2b28333f2c146a8689403d1e360c2c3f7b3a7801"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0460867ddbf29092f9639f851c1908d0afc559761547d2517b343246508512f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04ffedae81fd81ef01f25bc11e3518da30dcde4541ba2392e9412ff236a8f9e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eec697e65bc05417c1e3dde723b020475dc4df0f6ff01c24a6d9fd0c3f0412f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "395d3e9c0427bc0af353abe85023aefb7e82c29d7585ade7e422e55cd8b87acc"
    sha256 cellar: :any_skip_relocation, ventura:        "946fea53fbaf6fee3855943132943b84c76f3ee8fbd56b19a99f8b9efa8fbf3d"
    sha256 cellar: :any_skip_relocation, monterey:       "2417f59527b5a28206562bcd93dc96bf74df5226f41aaeffde428f4c3ee52189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69af641b210fe088b497e3ae2b734b49220072013e985ee9be15df99478b6fab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gau"
  end

  test do
    output = shell_output("#{bin}/gau --providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end