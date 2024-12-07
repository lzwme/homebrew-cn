class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https:github.commamba-orgmamba"
  url "https:github.commamba-orgmambaarchiverefstagsmicromamba-2.0.4.tar.gz"
  sha256 "29281fe9b8fa99ecaa01d791b00889fb953fdafa154bbdf877a0858044334439"
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
    sha256 cellar: :any,                 arm64_sequoia: "6498d862b65c8f8ef8c5b4710ca94821ae6f81a2963309b91124aef7a298a536"
    sha256 cellar: :any,                 arm64_sonoma:  "c13ac5bfdd98a891827ffc4c7ad9727a937fdfb293c5876045409e16941891bc"
    sha256 cellar: :any,                 arm64_ventura: "ea15e6ca847fd91fb3121db01cb33102cf43d5f8ebd3249ba5a12dbf3529c11b"
    sha256 cellar: :any,                 sonoma:        "1657ccea00701c78158946e3190790fa34619c9031659a23e1a5c431ccaf2f8c"
    sha256 cellar: :any,                 ventura:       "b04dfe232a8dcc21d9bb50ef66563c0b743c8b6ad15d6504ff5d3cc2fd5e238c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61714f97ff327ab0e3431bea99879a40ca58bc181109fbdba7dcaa384ddab82f"
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