class Pymol < Formula
  include Language::Python::Virtualenv

  desc "Molecular visualization system"
  homepage "https:pymol.org"
  url "https:github.comschrodingerpymol-open-sourcearchiverefstagsv3.1.0.tar.gz"
  sha256 "54306d65060bd58ed8b3dab1a8af521aeb4fd417871f15f463ff05ccb4e121fe"
  license :cannot_represent
  revision 1
  head "https:github.comschrodingerpymol-open-source.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "13f683c319c06b8e30f2b961c56e16a079b364780de4d237a5b35c576ce7bcfb"
    sha256 cellar: :any,                 arm64_ventura: "1fd72c9332cf93d45638faa9f2b39e8a1eb60694e6ef6c2466167ba3990fb935"
    sha256 cellar: :any,                 sonoma:        "8af0422ae606f64c6f0736f19b50ad315513e36ab4d8cec860767b988ac70c4a"
    sha256 cellar: :any,                 ventura:       "a6346a1171b662880f9f793835ce90420e32352b80e866a2a26a07dd2fc89879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af7204c635fb07c2cd01164d36765a20e9e297060cd94fb67d9d71d0a0509ddd"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "msgpack-cxx" => :build
  depends_on "sip" => :build

  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "pyqt"
  depends_on "python@3.13"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "freeglut"
    depends_on "mesa"
  end

  resource "mmtf-cpp" do
    url "https:github.comrcsbmmtf-cpparchiverefstagsv1.1.0.tar.gz"
    sha256 "021173bdc1814b1d0541c4426277d39df2b629af53151999b137e015418f76c0"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagescbd07555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4fmsgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "mmtf-python" do
    url "https:files.pythonhosted.orgpackagesd80ff3c132dc9aac9a3f32a0eba7a80f07d14e7624e96f9245eeac5fe48f42cdmmtf-python-1.1.3.tar.gz"
    sha256 "12a02fe1b7131f0a2b8ce45b46f1e0cdd28b9818fe4499554c26884987ea0c32"
  end

  resource "pmw" do
    url "https:github.comschrodingerpmw-patchedarchive8bedfc8747e7757c1048bc5e11899d1163717a43.tar.gz"
    sha256 "3a59e6d33857733d0a8ff0c968140b8728f8e27aaa51306160ae6ab13cea26d3"
  end

  def python3
    which("python3.13")
  end

  def install
    resource("mmtf-cpp").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath"mmtf")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    inreplace "setup.py" do |s|
      s.gsub!( no_glut = True$, " no_glut = False")
      s.gsub!( use_msgpackc = "guess"$, ' use_msgpackc = "c++11"')
    end

    ENV["PREFIX_PATH"] = "#{buildpath}mmtf:#{ENV["CMAKE_PREFIX_PATH"]}"
    venv = virtualenv_install_with_resources without: "mmtf-cpp"
    (prefixLanguage::Python.site_packages(python3)"homebrew-pymol.pth").write venv.site_packages
  end

  def caveats
    "To generate movies, run `brew install ffmpeg`."
  end

  test do
    (testpath"test.py").write <<~PYTHON
      from pymol import cmd
      cmd.fragment('ala')
      cmd.zoom()
      cmd.png("test.png", 200, 200)
    PYTHON

    system bin"pymol", "-cq", testpath"test.py"
    assert_path_exists testpath"test.png", "Amino acid image should exist"
    system python3, "-c", "import pymol"
  end
end