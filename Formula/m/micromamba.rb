class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https:github.commamba-orgmamba"
  url "https:github.commamba-orgmambaarchiverefstags2.0.8.tar.gz"
  sha256 "a62ff2c5bf79badd70fdecbf781a79aa1d4e687d889d613d17e242355031df78"
  license "BSD-3-Clause"
  head "https:github.commamba-orgmamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7cd081a8313bcc1f27d114d1d142feaf5ae160c2b5d862654e7795d227ca569f"
    sha256 cellar: :any,                 arm64_sonoma:  "bb7e2df9cb9adebb84324be6cc2fbc643b2910f3c79d368c259d0a10db130812"
    sha256 cellar: :any,                 arm64_ventura: "42afb6eb0eb92c16fa0b7774753e23fd582ff7a7d263b5b1b07246fd7c6bb9ed"
    sha256 cellar: :any,                 sonoma:        "d7782403ffef7b6e9b838aebb17b4364358a21bc9104f366089e7834c10515b8"
    sha256 cellar: :any,                 ventura:       "b76c4ddfa633c91b174253b46ba55b5c7d1871832a3bf49f5ad1ecd77da7469d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e20aac8fa5746fdb321c20ebf7b3135e9928ed4cb023f5fd80e49faa18a02c9e"
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