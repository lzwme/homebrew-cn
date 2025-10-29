class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghfast.top/https://github.com/mamba-org/mamba/archive/refs/tags/2.3.3.tar.gz"
  sha256 "4f1aaf3aa5098037c3fc1571feaa2d8f256829baafd6d5b4556624791e5c0217"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e1a946f5ca8d13b3b4d73e446d3c2a2debec1f316f729b0a459ef7f338081be"
    sha256 cellar: :any,                 arm64_sequoia: "9dc04da3c0b6c8f2c115d4e93064d66b7d20d891faeaf465da9f67aa117e0ea1"
    sha256 cellar: :any,                 arm64_sonoma:  "e98d796d506ad6111fe1221b7f67ad77db6d8980a428c2e4041e535302dae56e"
    sha256 cellar: :any,                 sonoma:        "08d1e1eb36129d477470747cedbc08f2ff2242b4f1ad06a64416f49181870e79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9abf47969b8ede6fc45751f29e852a32c83ce5e87022fd7011357adb3bf951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa989c17f9b91d2b82c7aebcaed077e287cca039e901acc2e37afbbea4844192"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build

  depends_on "fmt"
  depends_on "libarchive"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "reproc"
  depends_on "simdjson"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl", since: :ventura # uses curl_url_strerror, available since curl 7.80.0
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
    cause "Requires C++23 support for `std::ranges::views::join`"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1600

    args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_SHARED=ON
      -DBUILD_STATIC=OFF
      -DBUILD_MAMBA=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # Upstream chooses names based on static or dynamic linking,
    # but as of 2.0 they provide identical interfaces.
    bin.install_symlink "mamba" => "micromamba"
  end

  def caveats
    <<~EOS
      Please run the following to setup your shell:
        #{opt_bin}/mamba shell init --shell <your-shell> --root-prefix ~/mamba
      and restart your terminal.
    EOS
  end

  test do
    ENV["MAMBA_ROOT_PREFIX"] = testpath.to_s

    assert_match version.to_s, shell_output("#{bin}/mamba --version").strip
    assert_match version.to_s, shell_output("#{bin}/micromamba --version").strip

    # Using 'xtensor' (header-only package) to avoid "broken pipe" codesigning issue
    # encountered on macOS 13-arm and 14-arm during CI.
    system bin/"mamba", "create", "-n", "test", "xtensor", "-y", "-c", "conda-forge"
    assert_path_exists testpath/"envs/test/include/xtensor.hpp"
  end
end