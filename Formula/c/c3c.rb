class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https:github.comc3langc3c"
  license "LGPL-3.0-only"
  head "https:github.comc3langc3c.git", branch: "master"

  stable do
    url "https:github.comc3langc3carchiverefstagsv0.6.0.tar.gz"
    sha256 "d852ba9879a72582312fccc0d63f507d8a55f4716de2db423fe0ce329795ccbd"

    # Fix incorrect INLINE on const init function
    patch do
      url "https:github.comc3langc3ccommit8381dbbd8fc334778504ea96e11f929c5568ebe0.patch?full_index=1"
      sha256 "bdcf04510643c926a0508373db73a098d5b795f50051955fca2ecab516032560"
    end
  end

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5604a520f7169b1988f1780de3814864849e5260abc41ada7355f1f8e68958df"
    sha256 cellar: :any,                 arm64_ventura:  "c7ee673b139aa54a02a25b3893771acd653a59c7b9d7e902f1697541cfb310d6"
    sha256 cellar: :any,                 arm64_monterey: "b93c6b8fe3ee524d8c7d43efc0ff4a993b4b39863a5970db5a5195b79a34bbc3"
    sha256 cellar: :any,                 sonoma:         "264705b2712eff0e99a186ace79761684064b4109532e4344a7a83d43ef72a7b"
    sha256 cellar: :any,                 ventura:        "33542489d2539321d36242fbfeb17a52f5c5ffcd348b30090ae34be0cfc5dd2c"
    sha256 cellar: :any,                 monterey:       "bc7889411828daaeeeed367401afacbabf124d62ae7ea5c86f8074a5a921b422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e00967874f29ca64d6363cf41b9c5ca85cad30f9362951cd967fbbc5dfd28a4"
  end

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "z3"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c3").write <<~EOS
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    EOS
    system bin"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}test")
  end
end