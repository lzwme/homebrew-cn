class Manim < Formula
  include Language::Python::Virtualenv

  desc "Animation engine for explanatory math videos"
  homepage "https:www.manim.community"
  url "https:files.pythonhosted.orgpackages527929f287beebcf52464c2cfd88015720992515062dd373bd37c2ed34955cddmanim-0.19.0.tar.gz"
  sha256 "748115ffc1dea24940fd6d7a3edcae0ccedc3e1874ebc1f5d7e5c6d69a4f4505"
  license "MIT"
  head "https:github.commanimCommunitymanim.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c12c47570f9f36a78897bc9f6da054d19b3f998ea006b11e8e8c077a74568d8"
    sha256 cellar: :any,                 arm64_sonoma:  "3b08811b554fe8b591d735197fbd6282119570e898c3195cd62820c931fb8e2e"
    sha256 cellar: :any,                 arm64_ventura: "85d8948bc2a2205b1b881996712f670ff5036ec7f5fc69dafa8cb9442c31762b"
    sha256 cellar: :any,                 sonoma:        "b6ff89f0acf709ee9e919a5b07748dd69d7bfaea23247cfe684037711e104f69"
    sha256 cellar: :any,                 ventura:       "14fc3a46054ff6fe4fb88ba0baa90f47f841e1cb957c35fa3fb15827c43ec8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bd5aa7de4e8bae579787094e0a49fa01c2e79f3ebde576663ef4d262d6b2818"
  end

  depends_on "cmake" => :build # for mapbox_earcut
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

  resource "av" do
    url "https:files.pythonhosted.orgpackages0c9d486d31e76784cc0ad943f420c5e05867263b32b37e2f4b0f7f22fdc1ca3aav-13.1.0.tar.gz"
    sha256 "d3da736c55847d8596eb8c26c60e036f193001db3bc5c10da8665622d906c17e"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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
    url "https:files.pythonhosted.orgpackages8d700a322197c1178f47941e5e6e13b0a4adeaaa7c465c18e3b4ead3eba49860mapbox_earcut-1.0.3.tar.gz"
    sha256 "b6bac5d519d9947a6321a699c15d58e0b5740da61b9210ed229e05ad207c1c04"
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
    url "https:files.pythonhosted.orgpackages900292e235891300c901f59647112a0267a07454f58aeb2041aa44f6b85f9cb3moderngl_window-3.1.1.tar.gz"
    sha256 "29c2827505f87399f3461d480b2778910fddeebe44ea803301215cf212a6c1bc"
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
    url "https:files.pythonhosted.orgpackages2060bf154aba98e66bcc9d58e3d8bbea3d68a960f05b968a81693b17a76ece99pyglet-2.1.1.tar.gz"
    sha256 "47f49890a00e9fefc4d0ea74dc5b9d6b9be1c5455bb5746b2df118012cfa3124"
  end

  resource "pyglm" do
    url "https:files.pythonhosted.orgpackagesfea1123daa472f20022785b18d6cdf6c71e30272aae03584a8ab861fa5fa01a5pyglm-2.7.3.tar.gz"
    sha256 "4ccb6c027622b948aebc501cd8c3c23690293115dc98108f8ed3b7fd533b398f"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
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

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
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
    # beautifulsoup4 > hatchling, fix to `ZIP does not support timestamps before 1980` error
    ENV["SOURCE_DATE_EPOCH"] = Time.now.to_i.to_s

    if OS.mac?
      # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
    else
      without = resources.filter_map { |r| r.name if r.name.start_with?("pyobjc") }
    end
    virtualenv_install_with_resources(without:)

    generate_completions_from_executable(bin"manim", shells: [:fish, :zsh], shell_parameter_format: :click)
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