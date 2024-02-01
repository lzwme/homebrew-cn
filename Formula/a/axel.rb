class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https:github.comaxel-download-acceleratoraxel"
  url "https:github.comaxel-download-acceleratoraxelreleasesdownloadv2.17.12axel-2.17.12.tar.xz"
  sha256 "fb4e70535ebf732211af253bfe24f9ada57d80fd465ac02c721406c7d4e1d496"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5bf7a7d82a5e86b58951c2a3745bb5f15db0e115de2680d9fc6971bf80140ba8"
    sha256 cellar: :any, arm64_ventura:  "2f943e836a58412f0f678e41825d840c13302ab2db4ef0b3af04d024fa7e8c32"
    sha256 cellar: :any, arm64_monterey: "ab5580dc62ed8db9162cceeb96039b5220d91461825e78027ee93e8abdbe75ed"
    sha256 cellar: :any, sonoma:         "66870d8d4574bcde0f024da202fdd244eb93633061021b13f97016e78a09d569"
    sha256 cellar: :any, ventura:        "a0697ef3c0afa7e15e0674036631ac54dba8b131762e75ff7b88f746f9a125cd"
    sha256 cellar: :any, monterey:       "458367a0ab218da49d24578844893b3479b8b14ab528331176c4723627445c8d"
    sha256               x86_64_linux:   "60d7cc575b65f9b4117b4fc79234a62a1a06a5922e2a374ee2c923226693d716"
  end

  head do
    url "https:github.comaxel-download-acceleratoraxel.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gawk" => :build

    resource "txt2man" do
      url "https:github.commvertestxt2manarchiverefstagstxt2man-1.7.1.tar.gz"
      sha256 "4d9b1bfa2b7a5265b4e5cb3aebc1078323b029aa961b6836d8f96aba6a9e434d"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@3"

  # upstream patch PR, https:github.comaxel-download-acceleratoraxelpull425
  patch do
    url "https:github.comaxel-download-acceleratoraxelcommitfb8bb09257e3c5ce4da46d83fbb252c7fa74c933.patch?full_index=1"
    sha256 "8f71c3ac32a22a327662b29d61c87aa7aae6e77d20818ed758f9d42616f40da7"
  end

  def install
    if build.head?
      resource("txt2man").stage { (buildpath"txt2man").install "txt2man" }
      ENV.prepend_path "PATH", buildpath"txt2man"
      system "autoreconf", "--force", "--install", "--verbose"
    end
    system ".configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath"axel.tar.gz")
    system bin"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath"axel.tar.gz", :exist?
  end
end