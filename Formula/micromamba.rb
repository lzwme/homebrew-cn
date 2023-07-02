class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghproxy.com/https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.4.6.tar.gz"
  sha256 "ed4cde2cfc026c4e673ac65bd734d408d000fdbcf2ca2d9c0dbfbe0995507467"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0dd8d3a26f534b7709e3529009b8cf39150511ecc71800b55da136cf15649504"
    sha256 cellar: :any,                 arm64_monterey: "890a8ee7ed068f54fbaeb3950dc53c735351b90d8901e51a11a238eb0698c706"
    sha256 cellar: :any,                 arm64_big_sur:  "334c8f58f68778da4e3b0803f3f0fc722306f5131b17d1c8303d0d2e7a5f9967"
    sha256 cellar: :any,                 ventura:        "1b5b6fc2b73ca803fd8cfae3c64161dddad25a1c45efa26363e0c952fad111d0"
    sha256 cellar: :any,                 monterey:       "d66a8a90f4e383b0d8eade4b8c3dedec922e6f1cc8397dce8a5448ccd863681f"
    sha256 cellar: :any,                 big_sur:        "a18062a5afba02922af9d20919ac5ceb0d0b3994b283785e6bce8fccf4955e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "787f3c47f4a9898be789d9f977e5c905b121de0da3bfbd3435c74da40bd0ada6"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build
  depends_on "fmt"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "reproc"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :monterey # uses CURLINFO_RETRY_AFTER, available since curl 7.66.0
  uses_from_macos "krb5"
  uses_from_macos "libarchive", since: :monterey
  uses_from_macos "zlib"

  resource "libarchive-headers" do
    on_monterey :or_newer do
      url "https://ghproxy.com/https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-113.100.2.tar.gz"
      sha256 "db960cf112aaff48e2675148312b7e92c669fedc031205e88ec56af9a3ae2047"
    end
  end

  def install
    args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_SHARED=ON
      -DBUILD_MICROMAMBA=ON
      -DMICROMAMBA_LINKAGE=DYNAMIC
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    if OS.mac? && MacOS.version >= :monterey
      resource("libarchive-headers").stage do
        cd "libarchive/libarchive" do
          (buildpath/"homebrew/include").install "archive.h", "archive_entry.h"
        end
      end
      args << "-DLibArchive_INCLUDE_DIR=#{buildpath}/homebrew/include"
      ENV.append_to_cflags "-I#{buildpath}/homebrew/include"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Please run the following to setup your shell:
        #{opt_bin}/micromamba shell init -s <your-shell> -p ~/micromamba
      and restart your terminal.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micromamba --version").strip

    python_version = "3.9.13"
    system "#{bin}/micromamba", "create", "-n", "test", "python=#{python_version}", "-y", "-c", "conda-forge"
    assert_match "Python #{python_version}", shell_output("#{bin}/micromamba run -n test python --version").strip
  end
end