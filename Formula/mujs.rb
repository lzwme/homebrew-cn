class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.3.3",
      revision: "57e3f01d5f29c5823be725d96284488edf5f8ae1"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "57f55b475fce9fa70922a921ab4dddfa3965a792f49ec799a9611b3d7b1702cb"
    sha256 cellar: :any,                 arm64_monterey: "7330ba0c1e957592f3661a323899c79d3fbaf4ca7e48580d088d70690b10671f"
    sha256 cellar: :any,                 arm64_big_sur:  "f0ad6b7e39ffe4e5f1ed836c0f0e8c5d77ef16b4d7e875ae0c416a4a3c28068c"
    sha256 cellar: :any,                 ventura:        "4b3eaa4e4b9932d97c89dff726aa7ca304be22dfaa7784123aa24e1a015a0cc6"
    sha256 cellar: :any,                 monterey:       "e796d11fc60bc135656b59431e0ed715d488d705eac575985e91191c2435fe12"
    sha256 cellar: :any,                 big_sur:        "75b161624db6ed915a83d21c8da9a205c0585866540d5fef972764a97983636f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33d9cd1bca8a34431d33b59b5ad5bc3d245fc288646b39e586577fcf43df7e33"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "release"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-shared" if build.stable?
  end

  test do
    (testpath/"test.js").write <<~EOS
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    EOS
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
  end
end