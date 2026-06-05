class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghfast.top/https://github.com/mamba-org/mamba/archive/refs/tags/2.7.0.tar.gz"
  sha256 "56f378f3cc91ec9efb22881fa0d405eebdcabf6cc2180662a62c65f16df300dd"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "04c3bd6ec5fdc76b1a50a475f8c19dc95d927e8578ea260c656c4fa88ec19f3a"
    sha256 cellar: :any, arm64_sequoia: "4443efb9218c232d169b6e96da5b1f67f6da864618b1c08d3b6433648e7188e3"
    sha256 cellar: :any, arm64_sonoma:  "25d811044977570753f999e09f8aff4926d527e3e7a94967caec76f2a41d35ac"
    sha256 cellar: :any, sonoma:        "d284b29c0f84a20abf6c94eb2168f16685f5d21f6399e7d5ad5fa9d51c6f342e"
    sha256 cellar: :any, arm64_linux:   "4ce98e3e413e7fa3ca0ebcbf15605315ccb6f4be83f4da1f410ccf156e161797"
    sha256 cellar: :any, x86_64_linux:  "a62322c97ff9f620d8b153cee46246468de02d5367ad87af5bebf0fd6cb28f3d"
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