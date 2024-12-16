class Manim < Formula
  include Language::Python::Virtualenv

  desc "Animation engine for explanatory math videos"
  homepage "https:www.manim.community"
  url "https:files.pythonhosted.orgpackages835f717ba528eb191124211036ec710bafd605dc7f7bb948a41219a8dd1124b6manim-0.18.1.tar.gz"
  sha256 "4bf2b479d258b410259c6828261fe79e107beb8f2dd04ebfa73b96bcefdde93d"
  license "MIT"
  revision 2
  head "https:github.commanimCommunitymanim.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "38ff9acda51096f7d298f5198a87ef6e9b5b43413fd3d7488d5815ed7908a2eb"
    sha256 cellar: :any,                 arm64_sonoma:  "7040ccf7ee12b6616b0aab0d3a5ba1448ba3a3a90f399615743ff298360c7138"
    sha256 cellar: :any,                 arm64_ventura: "6b65945deb09217e16635e8f6e7a9c8a30d02865bb9d5b851fc9801d27bebdb3"
    sha256 cellar: :any,                 sonoma:        "ed7f3cc15f153b991b0b41d53ecfa525a554a44b86e84c574537ebb7cc1ee0ff"
    sha256 cellar: :any,                 ventura:       "416d06fd3f496835ae412ac8279b17103072044ab22a25dfad60633980a300fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc8bfd011829ab73b001ffb2a703442b3f9099ffa86e77c7dacfa66644504758"
  end

  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo" # for cairo.h
  depends_on "ffmpeg"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "numpy"
  depends_on "pango"
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "python@3.13"
  depends_on "scipy"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "cmake" => :build
    depends_on "patchelf" => :build
  end

  resource "audioop-lts" do
    url "https:files.pythonhosted.orgpackagesdd3b69ff8a885e4c1c42014c2765275c4bd91fe7bc9847e9d8543dbcbb09f820audioop_lts-0.2.1.tar.gz"
    sha256 "e81268da0baa880431b68b1308ab7257eb33f356e57a5f9b1f915dfb13dd1387"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cloup" do
    url "https:files.pythonhosted.orgpackagescf71608e4546208e5a421ef00b484f582e58ce0f17da05459b915c8ba22dfb78cloup-3.0.5.tar.gz"
    sha256 "c92b261c7bb7e13004930f3fb4b3edad8de2d1f12994dcddbe05bc21990443c5"
  end

  resource "cython" do
    url "https:files.pythonhosted.orgpackages844db720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aacython-3.0.11.tar.gz"
    sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "glcontext" do
    url "https:files.pythonhosted.orgpackages3a808238a0e6e972292061176141c1028b5e670aa8c94cf4c2f819bd730d314eglcontext-3.0.0.tar.gz"
    sha256 "57168edcd38df2fc0d70c318edf6f7e59091fba1cd3dadb289d0aa50449211ef"
  end

  resource "isosurfaces" do
    url "https:files.pythonhosted.orgpackagesdacfbd7e70bb7b8dfd77afdc79aba8d83afd4a9263f045861cd4ddd34b7f6a12isosurfaces-0.1.2.tar.gz"
    sha256 "fa51ebe864ea9355b26830e27fdd6a41d5a58b419fa8d4b47e3b8b80718d6e21"
  end

  resource "manimpango" do
    url "https:files.pythonhosted.orgpackages2a8e7f7a49d4bbe2c6dbef4a82c58e15fc5a35eedcf97a8f7c67ce5fa9a8c827manimpango-0.6.0.tar.gz"
    sha256 "d959708e5c05e87317b37df5f6c5258aa9d1ed694a0b25b19d6a4f861841e191"
  end

  resource "mapbox-earcut" do
    url "https:files.pythonhosted.orgpackages234b41fd15bf00ba781ad593b996c3650bcf3fc47a824abdacb18f4a91e07a1cmapbox_earcut-1.0.2.tar.gz"
    sha256 "83fa0468bcc23f300a1cbf9611bdc30c77aace9ab1d36821649f439490ee7d52"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "moderngl" do
    url "https:files.pythonhosted.orgpackagesda52540e2f8c45060bb2709f56eb5a44ae828dfcc97ccecb342c1a7deb467889moderngl-5.12.0.tar.gz"
    sha256 "52936a98ccb2f2e1d6e3cb18528b2919f6831e7e3f924e788b5873badce5129b"
  end

  resource "moderngl-window" do
    url "https:files.pythonhosted.orgpackages3c16de061149e35208cee45f1365019692a237046dc02fa413d07d28549c4811moderngl_window-3.0.3.tar.gz"
    sha256 "b6108c2396cc54d444c11d7fc77a4db0c2c9a4d74c438ab75ea0ea61949b3143"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackagesfd1d06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937fnetworkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "pycairo" do
    url "https:files.pythonhosted.orgpackages074a42b26390181a7517718600fa7d98b951da20be982a50cd4afb3d46c2e603pycairo-1.27.0.tar.gz"
    sha256 "5cb21e7a00a2afcafea7f14390235be33497a2cce53a98a19389492a60628430"
  end

  resource "pydub" do
    url "https:files.pythonhosted.orgpackagesfe9ae6bca0eed82db26562c73b5076539a4a08d3cffd19c3cc5913a3e61145fdpydub-0.25.1.tar.gz"
    sha256 "980a33ce9949cab2a569606b65674d748ecbca4f0796887fd6f46173a7b0d30f"
  end

  resource "pyglet" do
    url "https:files.pythonhosted.orgpackagesf7f49ff17629bbb818d6fd88f1d74ef117d4eba3bee8a54c14265f86a6c18f86pyglet-2.0.20.tar.gz"
    sha256 "702ea52b1fc1b6447904d2edd579212b29f1b3475e098ac49b57647a064accb7"
  end

  resource "pyglm" do
    url "https:files.pythonhosted.orgpackagesfea1123daa472f20022785b18d6cdf6c71e30272aae03584a8ab861fa5fa01a5pyglm-2.7.3.tar.gz"
    sha256 "4ccb6c027622b948aebc501cd8c3c23690293115dc98108f8ed3b7fd533b398f"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyobjc-core" do
    url "https:files.pythonhosted.orgpackages5d072b3d63c0349fe4cf34d787a52a22faa156225808db2d1531fe58fabd779dpyobjc_core-10.3.2.tar.gz"
    sha256 "dbf1475d864ce594288ce03e94e3a98dc7f0e4639971eb1e312bdf6661c21e0e"
  end

  resource "pyobjc-framework-cocoa" do
    url "https:files.pythonhosted.orgpackages39414f09a5e9a6769b4dafb293ea597ed693cc0def0e07867ad0a42664f530b6pyobjc_framework_cocoa-10.3.2.tar.gz"
    sha256 "673968e5435845bef969bfe374f31a1a6dc660c98608d2b84d5cae6eafa5c39d"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "screeninfo" do
    url "https:files.pythonhosted.orgpackagesecbbe69e5e628d43f118e0af4fc063c20058faa8635c95a1296764acc8167e27screeninfo-0.8.1.tar.gz"
    sha256 "9983076bcc7e34402a1a9e4d7dabf3729411fd2abb3f3b4be7eba73519cd2ed1"
  end

  resource "skia-pathops" do
    url "https:files.pythonhosted.orgpackagese5854c6ce1f1f3e8d3888165f2830adcf340922416c155647b12ebac2dcc423eskia_pathops-0.8.0.post2.zip"
    sha256 "9e252cdeb6c4d162e82986d31dbd89c675d1677cb8019c2e13e6295d4a557269"
  end

  resource "srt" do
    url "https:files.pythonhosted.orgpackages66b74a1bc231e0681ebf339337b0cd05b91dc6a0d701fa852bb812e244b7a030srt-3.5.3.tar.gz"
    sha256 "4884315043a4f0740fd1f878ed6caa376ac06d70e135f306a6dc44632eed0cc0"
  end

  resource "svgelements" do
    url "https:files.pythonhosted.orgpackages5d291c93c94a2289675ba2ff898612f9c9a03f46d69f253bdf4da0dfc08a599dsvgelements-1.9.6.tar.gz"
    sha256 "7c02ad6404cd3d1771fd50e40fbfc0550b0893933466f86a6eb815f3ba3f37f7"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "watchdog" do
    url "https:files.pythonhosted.orgpackagesdb7d7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  def install
    # Allow python 3.13: https:github.comManimCommunitymanimcommite74933049e7871832c1a623e128ef7bf82e2b8a4
    inreplace "pyproject.toml", 'python = ">=3.9,<3.13"', 'python = ">=3.9"'

    if OS.mac?
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
    else
      without = resources.filter_map { |r| r.name if r.name.start_with?("pyobjc") }
    end
    virtualenv_install_with_resources(without:)
  end

  test do
    (testpath"testscene.py").write <<~PYTHON
      from manim import *

      class CreateCircle(Scene):
          def construct(self):
              circle = Circle()  # create a circle
              circle.set_fill(PINK, opacity=0.5)  # set the color and transparency
              self.play(Create(circle))  # show the circle on screen
    PYTHON

    system bin"manim", "-ql", testpath"testscene.py", "CreateCircle"
    assert_path_exists testpath"mediavideostestscene480p15CreateCircle.mp4"
  end
end