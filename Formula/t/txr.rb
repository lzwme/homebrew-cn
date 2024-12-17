class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "https://www.kylheku.com/cgit/txr/snapshot/txr-297.tar.bz2"
  sha256 "4bed04af25fee80850e968da48762d2c00a45a4fa9afdb7d12a0e44cf6251389"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d23db0b6d66983a1350ccf0b066f5a5d56c4751b07fe97308567b2cc2503aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d5724e7d68b786f84a83002efdafe3f1ac077a039f58cc1184d7fb655196845"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5711bf047579ea1af3fa8d89e04c04dbdfc938455a052fc5a79c88c8203ff480"
    sha256 cellar: :any_skip_relocation, sonoma:        "314ec5871f465cb3a21bc714d0fdb7dc3c7dd17bb5b4c84d900678c51494f1fd"
    sha256 cellar: :any_skip_relocation, ventura:       "c286eff8db7d8342a47a1de80819d026de096153c347ba091a4fa49151029805"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end