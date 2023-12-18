class Robodoc < Formula
  desc "Source code documentation tool"
  homepage "https:rfsber.home.xs4all.nlRoboindex.html"
  url "https:rfsber.home.xs4all.nlRoboarchivesrobodoc-4.99.44.tar.bz2"
  sha256 "3721c3be9668a1503454618ed807ae0fba5068b15bc0ea63846787d7e9e78c0f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https:rfsber.home.xs4all.nlRoboarchives"
    regex(href=.*?robodoc[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "becedbbed4480801e9f68683d8b4d360699e4538b435a6f2da766b6142d02a31"
    sha256 arm64_ventura:  "daac2544b28bf80b15e7e55dc680058443e3c34b8c0405e3e8bc14b2bc1da871"
    sha256 arm64_monterey: "2b8577eec80c48eab7323c77dadb33617b8fde3ac834abbd8df2923cd4bc7748"
    sha256 sonoma:         "be14e9b85a7065d98b327d0b20d8515f7dcf05a6a1d6fed73a56443e669cbd8d"
    sha256 ventura:        "0043d16b63613205e223c9fe4128261d01204d961fd50a1b0945d69ccc763014"
    sha256 monterey:       "4b153cb1a62f10633593b400965dc3bec1350c4aeda23c2f0f6174dc8c3ff2da"
    sha256 x86_64_linux:   "960614e0d6ecfe4051cfe544814b4d4008222e2817a0d3146191a5ec7602d570"
  end

  head do
    url "https:github.comgumpuROBODoc.git", branch: "release"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fixes https:github.comgumpuROBODocissues22
  patch do
    url "https:github.comlutzmadROBODoccommit0f8b35c42523810415bec70bb2200d2ecb41c82f.patch?full_index=1"
    sha256 "5fa0e63deaf9eb0eb82e53047a684159d572c116b96fcf4aa61777b663eb156d"
  end

  def install
    system "autoreconf", "-f", "-i" if build.head?
    system ".configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    cp_r Dir["#{doc}ExamplesPerlExample*"], testpath
    system bin"robodoc"
  end
end