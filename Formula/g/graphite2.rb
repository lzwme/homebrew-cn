class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://graphite.sil.org/"
  url "https://ghfast.top/https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz"
  sha256 "f99d1c13aa5fa296898a181dff9b82fb25f6cc0933dbaa7a475d8109bd54209d"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MPL-1.1+"]
  head "https://github.com/silnrsi/graphite.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f21bef3300cfbed567eb476ac1825af9fd32abbcb222c1005b45aa6e3617347b"
    sha256 cellar: :any,                 arm64_sequoia:  "150b286ab4cfc8696fcd3fa4e7fa24c9825f024ef991899850b850e6f334100f"
    sha256 cellar: :any,                 arm64_sonoma:   "4cdee055db9958e12662c53661fab627057d3553974d15b289e2955b439f4a9d"
    sha256 cellar: :any,                 arm64_ventura:  "3ec770419ed60d211670f73bf078512824151b460c5c37740ee8b83e3dbb8357"
    sha256 cellar: :any,                 arm64_monterey: "2254ea02844280605c79ab735ce1c5eb4a943fe897c3119611de54169130a88e"
    sha256 cellar: :any,                 arm64_big_sur:  "544e2c344f6c0a7c2c3cb6541150f0d0d91cd1100460dac9c6a08578823f91c3"
    sha256 cellar: :any,                 sonoma:         "afd3067ded2f8fb2ae3400d908a271825c5f7013f089312949ac9576b2a26d96"
    sha256 cellar: :any,                 ventura:        "db73b7ef0318611d6dcf795cd4e43c5b62c5798190bc634dc94c6530e35afc46"
    sha256 cellar: :any,                 monterey:       "3469eaae77f6c9cb802730d060f26fd0bd56d390674490dc8b17c4624705df0e"
    sha256 cellar: :any,                 big_sur:        "ddc468a1eec491aed5d5b05b22d0cffa38b6059d87eab747301011507fcf6366"
    sha256 cellar: :any,                 catalina:       "0831f474c920b66bbeab3f93a91fa019b82bfffcdd40e369fdab76372700e980"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "06da87293745fa5229be472b70052a947e0ab3323c47782662a6fbbf2cd920c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e811b079268bc99d1b6253fc0c979e76325e91e294fd0596349dd0285e847b9"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "freetype" => :build
  end

  def install
    # CMake: Raised required version to 3.5
    cmake_policy_files = %w[CMakeLists.txt src/CMakeLists.txt]
    cmake_files = cmake_policy_files + %w[
      gr2fonttest
      tests/bittwiddling
      tests/json
      tests/sparsetest
      tests/utftest
    ].map { |f| "#{f}/CMakeLists.txt" }

    inreplace cmake_files, "CMAKE_MINIMUM_REQUIRED(VERSION 2.8.0 FATAL_ERROR)", "CMAKE_MINIMUM_REQUIRED(VERSION 3.5)"
    inreplace cmake_policy_files, "cmake_policy(SET CMP0012 NEW)", ""

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "testfont" do
      url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
      sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
    end

    resource("testfont").stage do
      shape = shell_output("#{bin}/gr2fonttest Simple-Graphite-Font.ttf 'abcde'")
      assert_match(/67.*36.*37.*38.*71/m, shape)
    end
  end
end