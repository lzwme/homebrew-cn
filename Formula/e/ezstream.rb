class Ezstream < Formula
  desc "Client for Icecast streaming servers"
  homepage "https:icecast.orgezstream"
  url "https:ftp.osuosl.orgpubxiphreleasesezstreamezstream-1.0.2.tar.gz"
  mirror "https:mirror.csclub.uwaterloo.caxiphreleasesezstreamezstream-1.0.2.tar.gz"
  sha256 "11de897f455a95ba58546bdcd40a95d3bda69866ec5f7879a83b024126c54c2a"
  license "GPL-2.0-only"

  livecheck do
    url "https:ftp.osuosl.orgpubxiphreleasesezstream?C=M&O=D"
    regex(%r{href=(?:["']?|.*?)ezstream[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9ad0d33e1b488f6859b2a467ccc55030a94eb8c07d12f13948f37aecf470d26c"
    sha256 cellar: :any,                 arm64_sonoma:   "14f8fd11da1cc6663aeffd97153a5b843e5b0bc4442ca26dbb6b3eae975fe348"
    sha256 cellar: :any,                 arm64_ventura:  "2dd9d7371e6fd462547e28d93e82f1351059b847a50b46dbb1a309c628c99fa7"
    sha256 cellar: :any,                 arm64_monterey: "22efe55635691409ca6c53eda5be73a7667c8ca59f0076b46380b67e663f5283"
    sha256 cellar: :any,                 arm64_big_sur:  "188838a38d3573fc77ffd5684e0e7759b24d550ffdd895243425e13c29e038c2"
    sha256 cellar: :any,                 sonoma:         "0fa4e1ba8a56f1ebec16abfc48be404bd85e4e1c7646c000398e121132f100d6"
    sha256 cellar: :any,                 ventura:        "ce167e9399770af979c88253224ef5e852192aef03ec4c5a64243612b91ec742"
    sha256 cellar: :any,                 monterey:       "07ec03e5e37aee0593f5d9121b9bc0ccb071df6c5ee520fc619991820ca90f31"
    sha256 cellar: :any,                 big_sur:        "fbfe1082559a1313ee3ff071ad35866fb20d5fb360fbfc634fbf85ac48c3e94d"
    sha256 cellar: :any,                 catalina:       "2854c21def8d7e97747aeca5e856833d17780698739e581a192059c58f50ffa2"
    sha256 cellar: :any,                 mojave:         "cfc4088a51cdcb0a586ee2a796d5a515d89007bebfae0f7bfd6b2a4c7a2c13f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c88f43345c0ebb3eca025869b579fa86820e12268fdb0e79d77fa2ee16a296"
  end

  head do
    url "https:gitlab.xiph.orgxiphezstream.git", branch: "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "check" => :build
  depends_on "pkgconf" => :build
  depends_on "libshout"
  depends_on "taglib"

  uses_from_macos "libxml2"

  # Work around issue with <sysrandom.h> not including its dependencies
  # https:gitlab.xiph.orgxiphezstream-issues2270
  patch :p0 do
    url "https:raw.githubusercontent.commacportsmacports-portsfa368818e58ecee010bd43f3c08e51c523ee8cf6audioezstreamfilessys-types.patch"
    sha256 "a5c39de970e1d43dc2dac84f4a0a82335112da6b86f9ea09be73d6e95ce4716c"
  end

  def install
    system "autoreconf", "--verbose", "--install", "--force" if build.head?
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath"test.m3u").write test_fixtures("test.mp3").to_s
    system bin"ezstream", "-s", testpath"test.m3u"
  end
end