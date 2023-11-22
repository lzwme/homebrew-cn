class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-292.tar.bz2"
  sha256 "b45a9a401098babedbe94e926ed8401a9d0756f22b7c3eb7c4c39bcf3238f4e8"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4476ee793d4faf42bc01f9a88afd03a4b23a5fb991940bc4d88cfb343e53746c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd513881a3cacc3d1bf803a6b9637c9336cb7453de4091fd1462d3c0ed14b282"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c3d34db5648685978df061f0d27a657bf64a148f6cb4cc71b2d9e0a556dece5"
    sha256 cellar: :any_skip_relocation, sonoma:         "84b3a0f1b43d38938f72a3d751f69153bcbb1ca85393962c3e28b6c5ee5b6c20"
    sha256 cellar: :any_skip_relocation, ventura:        "181293186a3c6031a67f52e5bbbaa4c6561198cc4697dd87ca140a8bebfd53b9"
    sha256 cellar: :any_skip_relocation, monterey:       "1d0d9324b34ed273ea2b33ad1ee326227a5047236d8eaf41aad440bfa65eecec"
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