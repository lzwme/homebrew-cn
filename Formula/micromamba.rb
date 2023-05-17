class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghproxy.com/https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.4.4.tar.gz"
  sha256 "035696ac379b7c6cbf87e912f7fa28c5f16ceaadf8f663d616cf0146e72390bb"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    regex(/^micromamba[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "738d72a7cedb519962d215551e6145e6a3874d13ab74820533f169ae3d97e826"
    sha256 cellar: :any,                 arm64_monterey: "da5c146580226d673ab1f29f8388768fc4670c32eb8d2257ab88e087950b4f1c"
    sha256 cellar: :any,                 arm64_big_sur:  "2091c1c71a2662385f8681f4ba99924719aa894ad61e72622ad27ab0dff5bd92"
    sha256 cellar: :any,                 ventura:        "da8023f7ea241d2d0ecd96f9b7773791edee0772ac6ccbaf266e7e97a8d4a163"
    sha256 cellar: :any,                 monterey:       "1e3c7a50ea33224ff7915b6fa95b840d49115d91ac9126a91ee9f71d90d166b2"
    sha256 cellar: :any,                 big_sur:        "05da9baab7c85a9594d4aae1648b7fa342e17e918f260656e16aea963e46f062"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72fc46d934af5c3242b3c898646e88a0ca0f7f089aa6b05960c1a14ce1f70049"
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