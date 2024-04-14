class Manim < Formula
  include Language::Python::Virtualenv

  desc "Animation engine for explanatory math videos"
  homepage "https:www.manim.community"
  url "https:files.pythonhosted.orgpackagesd383b504dbacb67c665e5b81f5aaa1b23fe058b8dac06c966b5c25949959a2a3manim-0.18.0.post0.tar.gz"
  sha256 "93d36a7a26cd8083969d22ebbc1c174a80cd193562d116a6dbf35622439e0035"
  license "MIT"
  revision 1
  head "https:github.commanimCommunitymanim.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7031070b960134606c1ee293f515ad3e475a59dbf644879ed78d24c58dd927f1"
    sha256 cellar: :any,                 arm64_ventura:  "347c9aaf873a2badcff0931464ce6cb2026774e51847d1e09da73af558d0b6d9"
    sha256 cellar: :any,                 arm64_monterey: "e7c1bc7eb6223af7768d186aed19fe52d36cf11659d7c80722798d56ac983260"
    sha256 cellar: :any,                 sonoma:         "c66cef188362b40a51efcf7322e89953b305bd4b8b7c7cc8d1a407e8d13545da"
    sha256 cellar: :any,                 ventura:        "5a51028f6795228bc474be14e58b60b873c261ecdcc12c2f539eb95c7476c624"
    sha256 cellar: :any,                 monterey:       "c0b9b1561348702bdb3206a1d5b2b377fea6eb76aa53187f32d20573a9ad3fe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9991ed32829ae9a4c3937cdc31eb09e75b8b06cb6b44c02cc2282e86d6ee8030"
  end

  depends_on "cython" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo" # for cairo.h
  depends_on "ffmpeg"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "python-setuptools" # for `import pkg_resources`
  depends_on "python@3.12"

  on_linux do
    depends_on "cmake" => :build
    depends_on "patchelf" => :build
  end

  on_arm do
    depends_on "pango"
    depends_on "scipy"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackages71dae94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96certifi-2024.2.2.tar.gz"
    sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https:files.pythonhosted.orgpackages1dceedb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41dfclick_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "cloup" do
    url "https:files.pythonhosted.orgpackages71b62819a7290c0f5bf384be3f507f2cfbc0a93a8148053d0bde2040d2e09124cloup-2.1.2.tar.gz"
    sha256 "43f10e944056f3a1eea714cb67373beebebbefc3f4551428750392f3e04ac964"
  end

  resource "cython" do
    url "https:files.pythonhosted.orgpackagesd5f72fdd9205a2eedee7d9b0abbf15944a1151eb943001dbdc5233b1d1cfc34eCython-3.0.10.tar.gz"
    sha256 "dcc96739331fb854dcf503f94607576cfe8488066c61ca50dfd55836f132de99"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "glcontext" do
    url "https:files.pythonhosted.orgpackages5eccb32b0cd5cd527a53ad9a90cd1cb32d1ff97127265cd026c052f8bb9e8014glcontext-2.5.0.tar.gz"
    sha256 "0f70d4be0cdd2b532a16da76c8f786b6367754a4086aaadffdbf3e37badbad02"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "isosurfaces" do
    url "https:files.pythonhosted.orgpackages88b6765e74b3ce5b40cf21b95eef7e60c7755314538908287ec2d0767b17bd2disosurfaces-0.1.0.tar.gz"
    sha256 "fa1b44e5e59d2f429add49289ab89e36f8dcda49b7badd99e0beea273be331f4"
  end

  resource "manimpango" do
    url "https:files.pythonhosted.orgpackages485bd1249c3d90324a1d4dce4711e507c8ec87addca61d1304ffa55513783ba3ManimPango-0.5.0.tar.gz"
    sha256 "299913bbccb0f15954b64401cf9df24607e1a01edda589ea77de1ed4cc2bc284"
  end

  resource "mapbox-earcut" do
    url "https:files.pythonhosted.orgpackages97f938f72877be0a5bf35c04a75c8ceb261589f2807eeaffaa22055079f53839mapbox_earcut-1.0.1.tar.gz"
    sha256 "9f155e429a22e27387cfd7a6372c3a3865aafa609ad725e2c4465257f154a438"
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
    url "https:files.pythonhosted.orgpackages25e7d731fc4b58cb729d337c829a62aa17bc2b70438fa59745c8c9f51e279f42moderngl-5.10.0.tar.gz"
    sha256 "119c8d364dde3cd8d1c09f237ed4916617ba759954a1952df4694e51ee4f6511"
  end

  resource "moderngl-window" do
    url "https:files.pythonhosted.orgpackagesc29014a7e798c9310dfa5ee94716d0b73f465780741ae6c9d45eb21626d87bf6moderngl-window-2.4.4.tar.gz"
    sha256 "66a9c5412b5eb0a5ca7cda351e4484ce02a167cf87eb4dc59bb82439c58130b5"
  end

  resource "multipledispatch" do
    url "https:files.pythonhosted.orgpackagesfe3ea62c3b824c7dec33c4a1578bcc842e6c30300051033a4e5975ed86cc2536multipledispatch-1.0.0.tar.gz"
    sha256 "5c839915465c68206c3e9c473357908216c28383b425361e5d144594bf85a7e0"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackagesc480a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3canetworkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "pillow" do
    url "https:files.pythonhosted.orgpackages00d54903f310765e0ff2b8e91ffe55031ac6af77d982f0156061e20a4d1a8b2dPillow-9.5.0.tar.gz"
    sha256 "bf548479d336726d7a0eceb6e767e179fbde37833ae42794602631a070d630f1"
  end

  resource "pycairo" do
    url "https:files.pythonhosted.orgpackages1c4191955188e97c7b85fbaac6bbf4e33de028899e0aa31bdce99b1afe2eeb17pycairo-1.26.0.tar.gz"
    sha256 "2dddd0a874fbddb21e14acd9b955881ee1dc6e63b9c549a192d613a907f9cbeb"
  end

  resource "pydub" do
    url "https:files.pythonhosted.orgpackagesfe9ae6bca0eed82db26562c73b5076539a4a08d3cffd19c3cc5913a3e61145fdpydub-0.25.1.tar.gz"
    sha256 "980a33ce9949cab2a569606b65674d748ecbca4f0796887fd6f46173a7b0d30f"
  end

  resource "pyglet" do
    url "https:files.pythonhosted.orgpackages7e21a514b8358e5f3c49e54edd055637ecb8e6f52af2d9c25bd0d9435c9fa6e0pyglet-2.1.dev1.tar.gz"
    sha256 "a94867222e656a097f26a713195a05bf471112e09bf46c4d9030555fc6a56fc4"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyobjc-core" do
    url "https:files.pythonhosted.orgpackages24ac61c58e65780c6ba0523997d236fac99e38e5ddfabfd5b500409f8239a257pyobjc-core-10.2.tar.gz"
    sha256 "0153206e15d0e0d7abd53ee8a7fbaf5606602a032e177a028fc8589516a8771c"
  end

  resource "pyobjc-framework-cocoa" do
    url "https:files.pythonhosted.orgpackagesb0c07eb30628e1a60c8b700f0b15280417c754eda9f186d05d47f4cac6f4e1a7pyobjc-framework-Cocoa-10.2.tar.gz"
    sha256 "6383141379636b13855dca1b39c032752862b829f93a49d7ddb35046abfdc035"
  end

  resource "pyrr" do
    url "https:files.pythonhosted.orgpackagese57f2af23f61340972116e4efabc3ac6e02c8bad7f7315b3002c278092963f17pyrr-0.10.3.tar.gz"
    sha256 "3c0f7b20326e71f706a610d58f2190fff73af01eef60c19cb188b186f0ec7e1d"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "scipy" do
    url "https:files.pythonhosted.orgpackagesfba3328965862f41ba67d27ddd26205962007ec87d99eec6d364a29bf00ac093scipy-1.13.0.tar.gz"
    sha256 "58569af537ea29d3f78e5abd18398459f195546bb3be23d16677fb26616cc11e"
  end

  resource "screeninfo" do
    url "https:files.pythonhosted.orgpackagesecbbe69e5e628d43f118e0af4fc063c20058faa8635c95a1296764acc8167e27screeninfo-0.8.1.tar.gz"
    sha256 "9983076bcc7e34402a1a9e4d7dabf3729411fd2abb3f3b4be7eba73519cd2ed1"
  end

  resource "skia-pathops" do
    url "https:files.pythonhosted.orgpackages3715fa6de52d9cb3a44158431d4cce870e7c2a56cdccedc8fa1262cbf61d4e1eskia-pathops-0.8.0.post1.zip"
    sha256 "a056249de2f61fa55116b9ee55513c6a36b878aee00c91450e404d1606485cbb"
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
    url "https:files.pythonhosted.orgpackagesea853ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "watchdog" do
    url "https:files.pythonhosted.orgpackages95a6d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ecwatchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r| r.name.start_with?("pyobjc") && OS.linux? }
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath"testscene.py").write <<~EOS
      from manim import *

      class CreateCircle(Scene):
          def construct(self):
              circle = Circle()  # create a circle
              circle.set_fill(PINK, opacity=0.5)  # set the color and transparency
              self.play(Create(circle))  # show the circle on screen
    EOS

    system bin"manim", "-ql", "#{testpath}testscene.py", "CreateCircle"
    assert_predicate testpath"mediavideostestscene480p15CreateCircle.mp4", :exist?
  end
end