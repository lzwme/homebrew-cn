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
    sha256 arm64_sequoia: "459bbe7021e6692558d602d179325151052d1bb1e54f5be6920ba964fb86a114"
    sha256 arm64_sonoma:  "aae55f7cbf6548f7cded61f52c1fe270ed71e6420587a1e501d3331aef246c91"
    sha256 arm64_ventura: "0a3f4ee88fbe4477b34c3cb69ec8f9ff41915226844553ad7e19e1f5afb98f9c"
    sha256 sonoma:        "c634f779d70b48aabd64322c6de6201cb71568573afb0403ac033a28cca0a8ce"
    sha256 ventura:       "f2b58c98f43016999d62ad8cc7e9e79ff47714f71b125f0fd28f4038259a3bdf"
    sha256 x86_64_linux:  "03697dd4da4ff2ec7692b5585b7288f34e92be772691e344b13a3caaa91f403a"
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

    args = %W[
      -DINSTALL_LIBDIR=#{lib}
      -DINSTALL_MANDIR=#{man}
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
    lib.glob(shared_library("*")) { |f| (lib"mariadb").install_symlink f }

    # TODO: Automatically compress manpages in brew
    Utils::Gzip.compress(*man3.glob("*.3"))
  end

  test do
    system bin"mariadb_config", "--cflags"
  end
end