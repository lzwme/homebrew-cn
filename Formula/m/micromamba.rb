class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https:github.commamba-orgmamba"
  url "https:github.commamba-orgmambaarchiverefstags2.0.7.tar.gz"
  sha256 "65510e216bd9704e8f4babbf7691583b7556afaf36703a5378d9215ffa23750e"
  license "BSD-3-Clause"
  head "https:github.commamba-orgmamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a6160f604d44ee2cad9ae0b69244d9c7d286a1ff320f289162df2bbd6a9cdc4a"
    sha256 cellar: :any,                 arm64_sonoma:  "c2a8570b2a8c9b24abc8d6777f4eaffe2c7dfded05629e1b9c9c62e7b2fa19f2"
    sha256 cellar: :any,                 arm64_ventura: "3f3aa310b110190ac0abb4497aa30aab21c4b822c41819af6a6780bc4ec82685"
    sha256 cellar: :any,                 sonoma:        "25fad5c34368232a0ac4add656c2a131140f9c3513c30c13c909e2915cbaf7f6"
    sha256 cellar: :any,                 ventura:       "2bb49fce7b532112cb8124911ef0aee1ee9a990a5c4c4a168592cb75165b14e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6982d04876912df76cb5af78256e80d186648b2e1e32bb13544d97d9c4850145"
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