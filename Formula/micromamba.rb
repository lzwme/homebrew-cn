class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghproxy.com/https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.4.3.tar.gz"
  sha256 "c173a3767ef7f32a7bd9f2ae1f68728fd4bc7df89b16b97c4c7f2b9fbe373898"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b4dd77d686417b32312f4dd6a12c4aaf904e7c0626e899ff51ad0e6e83dfd08"
    sha256 cellar: :any,                 arm64_monterey: "6ded5877a70f461db409c0e44c9c5dc55ec4cd70740e798b7814246b67a2232b"
    sha256 cellar: :any,                 arm64_big_sur:  "3fb39976bf693cc246c09e7eb5126b2d26e47fb2bf351c366234babeaae9112e"
    sha256 cellar: :any,                 ventura:        "c881f1b03b41529f5f780c6c516e63e1e54c3888613270d894941717b3ac33f5"
    sha256 cellar: :any,                 monterey:       "b70c54405b3ab2e4bb7ff37cd41efb44c3d88672b8f3d36686e3b42b3ba207ee"
    sha256 cellar: :any,                 big_sur:        "6f32097563576d06b2506b9b279b2f229396c7101d1f545a8038aa87f81a2d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b33ec2efd43034a61f57bb7d9958ff12bd6bc4b37ed5873a36b33d74894e385"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build
  depends_on "fmt"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@1.1"
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
      url "https://ghproxy.com/https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-113.tar.gz"
      sha256 "b422c37cc5f9ec876d927768745423ac3aae2d2a85686bc627b97e22d686930f"
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