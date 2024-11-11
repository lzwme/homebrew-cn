class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https:mariadb.orgdownload?tab=connector&prod=connector-c"
  # TODO: Remove backward compatibility library symlinks on breaking version bump
  url "https:archive.mariadb.orgconnector-c-3.4.1mariadb-connector-c-3.4.1-src.tar.gz"
  mirror "https:fossies.orglinuxmiscmariadb-connector-c-3.4.1-src.tar.gz"
  sha256 "0a7f2522a44a7369c1dda89676e43485037596a7b1534898448175178aedeb4d"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:github.commariadb-corporationmariadb-connector-c.git", branch: "3.4"

  # The REST API may omit the newest majorminor versions unless the
  # `olderReleases` parameter is set to `true`.
  livecheck do
    url "https:downloads.mariadb.orgrest-apiconnector-call-releases?olderReleases=true"
    strategy :json do |json|
      json["releases"]&.map do |_, group|
        group["children"]&.map do |release|
          next if release["status"] != "stable"

          release["release_number"]
        end
      end&.flatten
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "7164ff84f1e8eeb2e8efcb02f0ca31abd8a5997ebe1bf526b8c11edaaa7b7d34"
    sha256 arm64_sonoma:  "e16a19729204f5ba97e259012aa7d1abbd549c49a9b2610bb1fd3fafe2ab7ad4"
    sha256 arm64_ventura: "96fe4ece7f07237e0b1a344d99a1c181f3899a7990e3e6552ce819fea77e7dce"
    sha256 sonoma:        "36b1de0a183158468936ff52b5ef9d235893d2efe73e3c4fe25e16551f715912"
    sha256 ventura:       "9fd01a1f4f5c3460cc201893ff5c15e2471e8149944f46f13102f9cd9355f84b"
    sha256 x86_64_linux:  "e00754661abefb2555e56e422fa2db368fa4787d4210ed4eddca4e863437dde4"
  end

  keg_only "it conflicts with mariadb"

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    rm_r "external"

    # -DINSTALL_* are relative to prefix
    args = %w[
      -DINSTALL_LIBDIR=lib
      -DINSTALL_MANDIR=shareman
      -DWITH_EXTERNAL_ZLIB=ON
      -DWITH_MYSQLCOMPAT=ON
      -DWITH_UNIT_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Add mysql_config symlink for compatibility which simplifies building
    # some dependents. This is done in the full `mariadb` installation[^1]
    # but not in the standalone `mariadb-connector-c`.
    #
    # [^1]: https:github.comMariaDBserverblobmaincmakesymlinks.cmake
    bin.install_symlink "mariadb_config" => "mysql_config"

    # Temporary symlinks for backwards compatibility.
    # TODO: Remove in future version update.
    (lib"mariadb").install_symlink lib.glob(shared_library("*"))

    # TODO: Automatically compress manpages in brew
    Utils::Gzip.compress(*man3.glob("*.3"))
  end

  test do
    system bin"mariadb_config", "--cflags"
  end
end