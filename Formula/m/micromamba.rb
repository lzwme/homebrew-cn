class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghfast.top/https://github.com/mamba-org/mamba/archive/refs/tags/2.10.0.tar.gz"
  sha256 "396cf6c08f16ecbc0a98b45a3f14469911aa2f6dda9c3b4ca98d010cea017835"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "00a413935ece99a39602e9ece1c68c83e8a732d01699942f50e9b641134ab9eb"
    sha256 cellar: :any, arm64_tahoe:       "061bee86694da7be81ec06b9e351ce41fd4b6b600f53b6e4d51b14afa9c8f8bd"
    sha256 cellar: :any, arm64_sequoia:     "fcdad6e1da3c57aeeb8992aff82ce70412089d5de307affd905c80c9e325c68e"
    sha256 cellar: :any, arm64_linux:       "ae2a003a97e3249a148c2b03500aaf78851c9a5c158d43954b61f16b334a9725"
    sha256 cellar: :any, x86_64_linux:      "8c9fe0f59ad27eb65983f664293636d59dc64e805b0ba90b50faa82204e51163"
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
  depends_on "openssl@4"
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
    depends_on "howard-hinnant-date"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1600
    cause "Requires C++23 support for `std::ranges::views::join`"
  end

  fails_with :gcc do
    version "13"
    cause "Requires C++20 `std::chrono::parse`"
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