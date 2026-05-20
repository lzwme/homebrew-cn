class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghfast.top/https://github.com/mamba-org/mamba/archive/refs/tags/2.6.2.tar.gz"
  sha256 "cf085e4bbc5a3b2ec9c58761586287431453b604f75a87ea5990e252cab026fe"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "927863984a6955fc7af8df1b26bb726990333357a9fb5845d45362021098dd94"
    sha256 cellar: :any,                 arm64_sequoia: "fe5278ef1fbdec7d7ec23c216fe4a8992f7491c274cb4bb9b118d815e3ac17a1"
    sha256 cellar: :any,                 arm64_sonoma:  "b4f0e19ff35f7babc3bb3fd4c30a06bf18e86c3341db2b1bf017482492fbda04"
    sha256 cellar: :any,                 sonoma:        "d65d89a3e057a879cd6fbc73cb91aa50de4ba61babee1f1c07ac951eb5eddd30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f89bd8aae6d648b177f5a13ab7af4d864c9e74b7f6c11a5ad28e161efafd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46713829a5ffc5136e0be69363d25ca0901c30d0bfaed0a5387ecf6d663201c"
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
  depends_on "msgpack"
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

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1600
    cause "Requires C++23 support for `std::ranges::views::join`"
  end

  def install
    args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_LIBMAMBA_SPDLOG=ON
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