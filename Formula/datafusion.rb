class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://ghproxy.com/https://github.com/apache/arrow-datafusion/archive/refs/tags/28.0.0.tar.gz"
  sha256 "c8d98a1c206fd0aef436e5b337378e546c15b295038b45cf037b8966c584634a"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a82c63cc24399f4e91f4a52d4c71f5403182dd5b2ecaf0b15d79b9e025ca70e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75798ddcac6150862f731624f9c2544fac3d2316d2d7c2badb5b7dfab30c3af0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a4c1a21e3c6c6f5e463e97b22df72599e9060bc81cecbe2ee4a002ce163549f"
    sha256 cellar: :any_skip_relocation, ventura:        "26104296c137058608ef86b7316801eb0cefef65a89573db8779f7c8a3405b93"
    sha256 cellar: :any_skip_relocation, monterey:       "17c1c937d4cb29aa746a195ec3d24853ce1cda61230e3f3e64aff7463197903c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc3f93f719bdc97ae8c0ef551b88ec4abd8ac6a655b977b64af8a1eb979cb8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eabfc4fd514685c466e7df4e2412aa7f04239f4b7f27ccbdf21d61cf49a28807"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end