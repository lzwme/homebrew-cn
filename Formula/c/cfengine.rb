class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.24.1.tar.gz"
  sha256 "c73c3125052ddf3c6f2507a7062705104e3e1495396c71009e3ada3883751b1a"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    regex(/["']version["']:\s*["'](\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 arm64_sequoia: "f725b175040ab622809474f57ef2c849d9f0b0610175ad9c24d6e79d52d8e626"
    sha256 arm64_sonoma:  "169bfd10f3813bb149e10d2e7bc0a30afe8996a5917bd7e95a9213be904bc6d9"
    sha256 arm64_ventura: "511105a7ebe2c3674679bf6bf0fbfbf2db0f24c5773c5a327b9233f713121ab2"
    sha256 sonoma:        "543e420accc4bb2463b30b68ecd7c831cbbb9313a70d8fc6fc92d579ffaf95e2"
    sha256 ventura:       "96ab82d4a0ae7721c2e31a850bcf81a23bb521ff51c6400bb4c7fd27eb91a79f"
    sha256 x86_64_linux:  "20aa60575821934942208af520fb19e963f8bf5801e684243777d340d05a6c85"
  end

  depends_on "lmdb"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "curl", since: :ventura # uses CURLOPT_PROTOCOLS_STR, available since curl 7.85.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.24.1.tar.gz"
    sha256 "f1b05bcf9d7086200666225e77c9bb79cbf2ae3d67512b2122e4fc861a263e17"
  end

  def install
    odie "masterfiles resource needs to be updated" if version != resource("masterfiles").version

    args = %W[
      --with-workdir=#{var}/cfengine
      --with-lmdb=#{Formula["lmdb"].opt_prefix}
      --with-pcre2=#{Formula["pcre2"].opt_prefix}
      --without-mysql
      --without-postgresql
    ]

    args << "--with-systemd-service=no" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  def post_install
    workdir = var/"cfengine"
    secure_dirs = %W[
      #{workdir}/inputs
      #{workdir}/outputs
      #{workdir}/ppkeys
      #{workdir}/plugins
    ]
    chmod 0700, secure_dirs
    chmod 0750, workdir/"state"
    chmod 0755, workdir/"modules"
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end