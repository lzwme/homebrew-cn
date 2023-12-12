class Micromamba < Formula
  desc "Fast Cross-Platform Package Manager"
  homepage "https://github.com/mamba-org/mamba"
  url "https://ghproxy.com/https://github.com/mamba-org/mamba/archive/refs/tags/micromamba-1.5.5.tar.gz"
  sha256 "fe6e0d223062e7ce616e9d3aaa529cd11f1a46847f6cbaa8e87a6868570e108b"
  license "BSD-3-Clause"
  head "https://github.com/mamba-org/mamba.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest do |json, regex|
      json["name"]&.scan(regex)&.map { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "05cd431b3728b1baedae9092dd1f735d60501f0aab1f59c7fa35e62688f5a216"
    sha256 cellar: :any,                 arm64_ventura:  "37751ba0382f0b143fac12ad9f8175e82bc89d13ccba1dd42e1e290c57ad13b4"
    sha256 cellar: :any,                 arm64_monterey: "a057725e6d77f8b733df8b5a332dfc2feb221991be18d8c417d1171e93d20f4d"
    sha256 cellar: :any,                 sonoma:         "d1f0bd48866ccffc24f2fcc25f1e46d8e3f303c914bddbd7b4cf56198fb037aa"
    sha256 cellar: :any,                 ventura:        "8487d2ec0e57da536fe347075dd6bf14e95a10dda27dcd74b725228d57262ba6"
    sha256 cellar: :any,                 monterey:       "36caf9d2c99d95362a094b167d54f12cfd032d10fae66e746154e2e6f81fb7e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e147d0ca250e7e4346f6d1e5ef64daa7fbde95564e433b283facf3550bcbb7a"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "spdlog" => :build
  depends_on "tl-expected" => :build
  depends_on "fmt"
  depends_on "libsolv"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "reproc"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :ventura # uses curl_url_strerror, available since curl 7.80.0
  uses_from_macos "krb5"
  uses_from_macos "libarchive", since: :monterey
  uses_from_macos "zlib"

  resource "libarchive-headers" do
    on_monterey :or_newer do
      url "https://ghproxy.com/https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-121.40.3.tar.gz"
      sha256 "bb972360581fe5326ef5d313ec51579b1c1a4c8a6f20a5068851032a0fa74f33"
    end
  end

  def install
    args = %W[
      -DBUILD_LIBMAMBA=ON
      -DBUILD_SHARED=ON
      -DBUILD_MICROMAMBA=ON
      -DMICROMAMBA_LINKAGE=DYNAMIC
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    if OS.mac? && MacOS.version >= :monterey
      resource("libarchive-headers").stage do
        cd "libarchive/libarchive" do
          (buildpath/"homebrew/include").install "archive.h", "archive_entry.h"
        end
      end
      args << "-DLibArchive_INCLUDE_DIR=#{buildpath}/homebrew/include"
      ENV.append_to_cflags "-I#{buildpath}/homebrew/include"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Please run the following to setup your shell:
        #{opt_bin}/micromamba shell init -s <your-shell> -p ~/micromamba
      and restart your terminal.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micromamba --version").strip

    python_version = "3.9.13"
    system "#{bin}/micromamba", "create", "-n", "test", "python=#{python_version}", "-y", "-c", "conda-forge"
    assert_match "Python #{python_version}", shell_output("#{bin}/micromamba run -n test python --version").strip
  end
end