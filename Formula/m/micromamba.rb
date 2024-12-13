class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https:github.commamba-orgmamba"
  url "https:github.commamba-orgmambaarchiverefstagsmicromamba-2.0.5.tar.gz"
  sha256 "f3c4d39921b2036aa77e1093cb21006bf8787f720a11a2a1ef9a80568d660bf3"
  license "BSD-3-Clause"
  head "https:github.commamba-orgmamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4fe1618a5b953dbeb7e66a183104a09e14038ec9a18668eb094ec50e2224e1ca"
    sha256 cellar: :any,                 arm64_sonoma:  "ba030e1730f4d4ae6300cfbd75ca7db2eb2de5cf7c69c2f93ae271b999d7c20d"
    sha256 cellar: :any,                 arm64_ventura: "502f113bbcc4175c60fcbfe3e730a11a71bd75c2f4d06e1aef3d20ae13e9b8d9"
    sha256 cellar: :any,                 sonoma:        "6c3d6a3ba4850c7dbe0cb9df0b5103d21a84bd80c43b438804c5007a2965d8ff"
    sha256 cellar: :any,                 ventura:       "7dcc4d3843e942829ba41187b8161f17fa26c9c15a3efce31db6f322574ed478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d513c5ea35990bd0a04fb87628dc0ddb3de2f248f1892a7b0cb20f3bfc271f"
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