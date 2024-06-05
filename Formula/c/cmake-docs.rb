class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https:www.cmake.org"
  url "https:github.comKitwareCMakereleasesdownloadv3.29.4cmake-3.29.4.tar.gz"
  mirror "http:fresh-center.netlinuxmisccmake-3.29.4.tar.gz"
  mirror "http:fresh-center.netlinuxmisclegacycmake-3.29.4.tar.gz"
  sha256 "b1b48d7100bdff0b46e8c8f6a3c86476dbe872c8df39c42b8d104298b3d56a2c"
  license "BSD-3-Clause"
  head "https:gitlab.kitware.comcmakecmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51178171ddc80943f2bd590ac495b3a67aceabb5749f8910d108f26780dc899a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51178171ddc80943f2bd590ac495b3a67aceabb5749f8910d108f26780dc899a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51178171ddc80943f2bd590ac495b3a67aceabb5749f8910d108f26780dc899a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5757132d0b31fa70435ea9c68a34849b5b948181bb95a1887b54f09813ef8e66"
    sha256 cellar: :any_skip_relocation, ventura:        "5757132d0b31fa70435ea9c68a34849b5b948181bb95a1887b54f09813ef8e66"
    sha256 cellar: :any_skip_relocation, monterey:       "5757132d0b31fa70435ea9c68a34849b5b948181bb95a1887b54f09813ef8e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51178171ddc80943f2bd590ac495b3a67aceabb5749f8910d108f26780dc899a"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cmake", "-S", "UtilitiesSphinx", "-B", "build", *std_cmake_args,
                                                             "-DCMAKE_DOC_DIR=sharedoccmake",
                                                             "-DCMAKE_MAN_DIR=shareman",
                                                             "-DSPHINX_MAN=ON",
                                                             "-DSPHINX_HTML=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share"doccmakehtml"
    assert_path_exists man
  end
end