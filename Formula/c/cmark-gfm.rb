class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://ghproxy.com/https://github.com/github/cmark-gfm/archive/refs/tags/0.29.0.gfm.13.tar.gz"
  version "0.29.0.gfm.13"
  sha256 "5abc61798ebd9de5660bc076443c07abad2b8d15dbc11094a3a79644b8ad243a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "02ea9335249ea4b4749ebdb3770deadd78e9e135431ad4552ff23941fe83edb9"
    sha256 cellar: :any,                 arm64_ventura:  "db367b57679f3f5ff972e89fb35c51fb30bbb343ce8e13b9202bf202ca8ae24b"
    sha256 cellar: :any,                 arm64_monterey: "88f430ffc95c1e948082963bd58dc7b710033f69b7aa74b11d4f4fd7c567603a"
    sha256 cellar: :any,                 arm64_big_sur:  "1cc456ff30491754d4ee3a1197e3e409ca1f5563183b50bbde899e0864f8942e"
    sha256 cellar: :any,                 sonoma:         "eda0aadb3e858244f38c388210772ece97d5146ef6aa64c34586752422596b22"
    sha256 cellar: :any,                 ventura:        "e69573db28aff177eec22651c2ccb5b7be8863b8d4f1edd816ab67eb9da9c05b"
    sha256 cellar: :any,                 monterey:       "4cca4929db9ff31ee827b74d4683662af0a48e4577f95507216073ffff37a22b"
    sha256 cellar: :any,                 big_sur:        "f0ae4dd8836af5cb5e7de552916c9c8dc9fe2b839c79be70f504cf5777ec14e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cc57585e59c81673c7cb0c374c59f900778886de3329127706534eb8851a0b5"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    system "cmake", "-S", ".", "-B", "build",
                        "-DCMAKE_INSTALL_RPATH=#{rpath}",
                        *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end