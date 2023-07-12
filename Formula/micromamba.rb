class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghproxy.com/https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.4.8.tar.gz"
  sha256 "daf5a770d745dfc562348a8fea3114b5c8fdfdd9683e4bf86552733e0cc2cf38"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "188abeb2fb89894af2021f31a1e62def001c066d4e75fdd834e8e59abd8499cf"
    sha256 cellar: :any,                 arm64_monterey: "8c19f4dd267de7f4ad6e31ce9f89e80b7aa84b54233cc2b39ab95e8e82932f24"
    sha256 cellar: :any,                 arm64_big_sur:  "1dc450389c8266e5f6ab7385a0d587287756e379cf7267a33f9527f5e2c8e4ee"
    sha256 cellar: :any,                 ventura:        "023d377dca919b5400ee069e5e778fc34f849fb66e656de2aef1e6575a6eaa20"
    sha256 cellar: :any,                 monterey:       "fe093ce74e865cb20f3b0c93b0f33c89d8da19e43022cb74c4ba004db9a3e14f"
    sha256 cellar: :any,                 big_sur:        "79e49f56013ce9ef2a9d5e5f49f8122419a6b5b0cf2a44ba03bc712e6e4d929c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea371371b3b9f2b7f3e0ba95d0cd136797bcaa2c2a278b98b4aaa7b2a027f27"
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