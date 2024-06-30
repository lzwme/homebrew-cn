class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "https://www.kylheku.com/cgit/txr/snapshot/txr-295.tar.bz2"
  sha256 "d072eb6cee2fe207e4f79c394885de43fa0d40c08c2810e486d54989542d0985"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c36b75238f2c1a741b2a8f96b234c6d1deb7eb4d95054fa8f01197bb4df75723"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26df870b893ae44270bd240a64cbe16545aa159794a27e49dcd3a0af5aae6f67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c79b198a2eeec4f2d002b7dd5c6ec66a45fc9ac0a349c35567a5e239696b9a9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d48ce4228bf1ef17559861d2f561973ff03db6fc2ede31fe0696f7cd5df2b97"
    sha256 cellar: :any_skip_relocation, ventura:        "a948c5638f3c3f3814bd6dd68ce3410b95319aedeaf5f1cf6ebd77a736ef5afa"
    sha256 cellar: :any_skip_relocation, monterey:       "38a9dcaadc775cbd6aa1ec53a795a58c15eff8b46d4853c016bdfb98cc044083"
  end

  depends_on "pkg-config" => :build
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