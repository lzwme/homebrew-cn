class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.31.0.tar.gz"
  sha256 "fbd7b27dc6aa82dcee98a0a41e142db1921ffc60f6f2bfde0d8e95cf3ae3974c"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "820c02118a913abb567483808f29aeef84e38deabf84875b44f5fe059defa0fd"
    sha256 cellar: :any,                 arm64_sonoma:  "e12a7bdb4f8ca31a330541e39cf07e1483a532854f7790af7accb8076c78d9b2"
    sha256 cellar: :any,                 arm64_ventura: "720fe923c9049fd17c70571032437aee225ddb106a03cd7899a3b24c6d775604"
    sha256 cellar: :any,                 sonoma:        "90b1dc1fc6cc4c5be3eccf9bb466ab2b42736b13f9644f20ebad066ee4c1a8b4"
    sha256 cellar: :any,                 ventura:       "1f83d11a05e8945efdb07a121bb8967c25a553577d8fbde5d47f64da41410f82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c547a904e9d35a4473c197eabb5a325498e45fa86c73475cf931e310f49fdf16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95fa37ae64f649695c4e203e8f281f0543ffd2dcf8fd9a7781ac483e680daf65"
  end

  depends_on "readline"

  conflicts_with "oil", because: "both install 'osh' and 'ysh' binaries"
  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--readline=#{Formula["readline"].opt_prefix}",
                          "--with-readline"
    system "_build/oils.sh"
    system "./install"
  end

  test do
    system bin/"osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"ysh", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/ysh -c 'var foo = \"bar\"; write $foo'").strip
  end
end