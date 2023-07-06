class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghproxy.com/https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.4.7.tar.gz"
  sha256 "f09914215f626564da516b676a5cf64d8e3c4c8202c5524983cae3a03ce36689"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4a288ea09f29e248fc392be1f2009b8a437b9b73e531e6a35732ec4c78fc5346"
    sha256 cellar: :any,                 arm64_monterey: "6101844279a9f40d743f40e6cf366a648d9ac164f76442ef1d130fd3e97491d3"
    sha256 cellar: :any,                 arm64_big_sur:  "59726a643f639c181b4c5ccdd590f7c1b69ca78281f9795b4bc4ba05eecc572b"
    sha256 cellar: :any,                 ventura:        "f44bd708c93c5b3e054c8383a08b4e89bd0e70426a4263bae8800238853176d7"
    sha256 cellar: :any,                 monterey:       "c68f324dde83ebb9c0f4cb89fb67aafa7076fac5072306f4ebfb475e4e4f4c76"
    sha256 cellar: :any,                 big_sur:        "e6a5fc8b7e15596f7b15ba43ff30c5fef4bc733e08a9868d5c7fb51502a0c37d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc784725f0a3cf430c6db3f03e7ae755be899e5b880f4459db7ef2baaf6b17c"
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