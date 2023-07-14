class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghproxy.com/https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.4.9.tar.gz"
  sha256 "cfa63d261488ac82adf4ed8efe18d39bcccaa40a5fda7b485b110abdb814b36b"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ecf73e56f0d13780df52bc2736fcafe997ce674f622ac74d6aba137c175ea58d"
    sha256 cellar: :any,                 arm64_monterey: "b6005b6aa910374a1ca6d872734c1e60fb9ad8dfd6cda7b682df14fdb7690238"
    sha256 cellar: :any,                 arm64_big_sur:  "2b03162f5c0439a83fbfaadcc54e0c0170396f2790f169f6b21ddd0363d79320"
    sha256 cellar: :any,                 ventura:        "c46600b046a164b210e8f8d49e8c67b1c842afb85559ed9c6fd08f7d1340f6d6"
    sha256 cellar: :any,                 monterey:       "cde34b2652b394f368d000b7268022642ece900c1e7bbb0b57ee0810c7efa5d6"
    sha256 cellar: :any,                 big_sur:        "ec6d2baa9519c2cdcbd3a1e70563daf1327474dcfcdfc2c9ecc37e4d185ab565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a209d4278b4f540dcb345c06d5958fd21f70c65f3c4e22e95a90d0bbf579a383"
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