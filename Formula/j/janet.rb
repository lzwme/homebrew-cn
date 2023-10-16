class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://ghproxy.com/https://github.com/janet-lang/janet/archive/v1.32.0.tar.gz"
  sha256 "d18e42b711d70254f4e0604049aa0d7307de0b92f622c6c61740838fc93cf1cb"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c07c02eb58a2f9829cd49cb64d891e30dadf975fa527e500c62dc8b78c18115b"
    sha256 cellar: :any,                 arm64_ventura:  "0411d13ce9569e3523221d01c840e4e5bd6b84fcb9352e6d7f2af040a34687bf"
    sha256 cellar: :any,                 arm64_monterey: "cffcc1129e59559d172e17fc794d02ae33f3462d0842d3854c0f319fc242e157"
    sha256 cellar: :any,                 sonoma:         "0db0e8ffa5f6237949570e00cba748a9325b54ddb4e95f0211089b415c273f63"
    sha256 cellar: :any,                 ventura:        "e1be818482a3907ea0d161a4b6987e96ee39b86718812ee7f03e85d4f9e92feb"
    sha256 cellar: :any,                 monterey:       "32e9368f26eda3b18c11079c769b8235d810645205b101ee34431dec7491a1b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fa2d1ff81a44dbabe5129f3a0e7d345c4feb1b4e34015102bbb527799147945"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  resource "jpm" do
    url "https://ghproxy.com/https://github.com/janet-lang/jpm/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "337c40d9b8c087b920202287b375c2962447218e8e127ce3a5a12e6e47ac6f16"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
    ENV["PREFIX"] = prefix
    resource("jpm").stage do
      system bin/"janet", "bootstrap.janet"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :exist?, "jpm must exist"
    assert_predicate HOMEBREW_PREFIX/"bin/jpm", :executable?, "jpm must be executable"
    assert_match prefix.to_s, shell_output("#{bin}/jpm show-paths")
  end
end