class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghproxy.com/https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.5.0.tar.gz"
  sha256 "0323e3a380d2a4b2bf20ef2520d271681480a6885b1505c3787e3683cbe58b17"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "088b899f45d7d27004c5d5956fb379a04aa3c0e8e4c1d9aceffe5bbaccd4f518"
    sha256 cellar: :any,                 arm64_monterey: "c2454216be12df37fa80b1904b03593fbcd3c1defdc5819a9210f67e84e97887"
    sha256 cellar: :any,                 arm64_big_sur:  "b59cc65c12449dd7f291de0ee2e94780140210bf3cbc26f052ba6fe633623824"
    sha256 cellar: :any,                 ventura:        "71d4ea83cf953beaba038750e1b8a45ed07d91e4ae8f3e9ea4c90442ab4b2bb8"
    sha256 cellar: :any,                 monterey:       "6ff7fcc2e1d8cb005606e2d7f3a49884f6623ca84ca3cabfc2888cfdb4c46261"
    sha256 cellar: :any,                 big_sur:        "b4b8584fa41bc7a1f874d6a0cf907c091f70088cf524c8badfb98b0f1a9ca65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cc91b26bba13242c904e89a29b9768db35ebcf0aad84212795375a8ff89d278"
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
  uses_from_macos "curl", since: :ventura # uses curl_url_strerror, available since curl 7.80.0
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