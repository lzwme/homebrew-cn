class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://ghfast.top/https://github.com/geographiclib/geographiclib/archive/refs/tags/r2.5.1.tar.gz"
  sha256 "7467c5d3bf368d7654dfa0e75af6a1d40a9e530995f2db84672e57c04a447823"
  license "MIT"
  head "https://github.com/geographiclib/geographiclib.git", branch: "main"

  livecheck do
    url :stable
    regex(/^r(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6fbbe8bb21ac056d840d5d03186353bef3f79452051e258e69fd51bf37c0e0eb"
    sha256 cellar: :any,                 arm64_sonoma:  "7caa196740c1c429926ebbb1c7223e81f4cf51d4d715995f499844cc2e7a673c"
    sha256 cellar: :any,                 arm64_ventura: "862169ff659b38105b409b13db88b56d0743ca0c80106c0cc6574364d053cc5d"
    sha256 cellar: :any,                 sonoma:        "143ec9b7917ab11028c81448509cfe999f94a2fbfba8ea9edb5618401255b30d"
    sha256 cellar: :any,                 ventura:       "4318f9ceb52fb9d374d99568bdc64376c05e6290afaf67d12f916a0182797cd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8678bb9c0f7d0fb1b9731e7313d847d4c524af7845cd41037f3e8b089fc167ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "156d4e1cff55bfaf96c4cbf1d9628132a8f61f1f9fcad010a06e1f5b6fda9862"
  end

  depends_on "cmake" => :build

  def install
    args = ["-DEXAMPLEDIR="]
    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end