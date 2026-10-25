class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghfast.top/https://github.com/mamba-org/mamba/archive/refs/tags/2.10.0.tar.gz"
  sha256 "396cf6c08f16ecbc0a98b45a3f14469911aa2f6dda9c3b4ca98d010cea017835"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eb3316a00933c879150edd9cef87d721ee2debc66301724760bd0f7d0fb176db"
    sha256 cellar: :any, arm64_tahoe:       "2a3efb4486e348d323b1cd238acaa8ec6627ed4b4e23c5df2f23a9de2a8fb27f"
    sha256 cellar: :any, arm64_sequoia:     "7653622cd7e01aa4f60f0c4a1c630224fd10987ce0bd31a85ba81dd4143799aa"
    sha256 cellar: :any, arm64_linux:       "20571b70fbe3c1189b350d94f7d0b43d99310df3168cb221768e1ad05eed1313"
    sha256 cellar: :any, x86_64_linux:      "7795008297fc390dbd307873b5d2b71ec34b78381d91dcf785aee44e8e4ce542"
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