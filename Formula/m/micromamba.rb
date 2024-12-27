class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https:github.commamba-orgmamba"
  url "https:github.commamba-orgmambaarchiverefstagsmicromamba-2.0.5.tar.gz"
  sha256 "f3c4d39921b2036aa77e1093cb21006bf8787f720a11a2a1ef9a80568d660bf3"
  license "BSD-3-Clause"
  revision 1
  head "https:github.commamba-orgmamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6dd6b3ae536052b00413ea3c46775fc0b4dec06230bf93e27e0eb89592eee558"
    sha256 cellar: :any,                 arm64_sonoma:  "3a2c3076c02cf7ab2e21859fcf97f7d1b0de73db9121b2db60a940550deaa8f8"
    sha256 cellar: :any,                 arm64_ventura: "33ccc786e9e29b4346a4131e16e6c6cad940026953c3c2584721dc022f71e6a3"
    sha256 cellar: :any,                 sonoma:        "76b43513c6fe4aab13ae10d740ea14e3e2d47ba4b52a0006aa049ce3233f8bfb"
    sha256 cellar: :any,                 ventura:       "b9718615d797c08b434658efa0f4ab46c940e8a70adaaae5a93fdab340aec312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "803e44cde62fcf780e1ef032e6b4de78fb7ea96ab9b2bca66fa6b6e679ac9134"
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

  def install
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
        #{opt_bin}mamba shell init --shell <your-shell> --root-prefix ~mamba
      and restart your terminal.
    EOS
  end

  test do
    ENV["MAMBA_ROOT_PREFIX"] = testpath.to_s
    assert_match version.to_s, shell_output("#{bin}mamba --version").strip
    assert_match version.to_s, shell_output("#{bin}micromamba --version").strip

    python_version = "3.9.13"
    system bin"mamba", "create", "-n", "test", "python=#{python_version}", "-y", "-c", "conda-forge"
    assert_match "Python #{python_version}", shell_output("#{bin}mamba run -n test python --version").strip
  end
end