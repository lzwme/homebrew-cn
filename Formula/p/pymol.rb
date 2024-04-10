class Pymol < Formula
  include Language::Python::Virtualenv
  desc "Molecular visualization system"
  homepage "https:pymol.org"
  url "https:github.comschrodingerpymol-open-sourcearchiverefstagsv3.0.0.tar.gz"
  sha256 "45e800a02680cec62dff7a0f92283f4be7978c13a02934a43ac6bb01f67622cf"
  license :cannot_represent
  head "https:github.comschrodingerpymol-open-source.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e18ee8f5f5310556143fd5b093b80538b37b337c560396daf0ccc682f064cf8"
    sha256 cellar: :any,                 arm64_ventura:  "fba9d3492af06c5ec91d4f2aa778425aed56659310ea14615bcd3053eb002cbc"
    sha256 cellar: :any,                 arm64_monterey: "b76f0d1ac201b7363fd2560c1191f79331d318692884fd51b338fc936108d859"
    sha256 cellar: :any,                 sonoma:         "7296fcbf89c9504725d3f5198b3d067d2451a4630f1f49cf12a92f1431d1c6fc"
    sha256 cellar: :any,                 ventura:        "9c30477040def3bdcdd10b7debcdd4f163242562d6afcb00de78783c88e84cfb"
    sha256 cellar: :any,                 monterey:       "7348bb8c03502268d926401aa61f32a217bbe2910dc890ecc5c682ef743c2670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ffbb1a42540070463982069ebf3516f109ca9c22a850939dd7abd7d01dd82ee"
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
  depends_on "pyqt@5"
  depends_on "python-setuptools" # for pymolpluginsinstallation.py
  depends_on "python@3.12"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "freeglut"
  end

  resource "mmtf-cpp" do
    url "https:github.comrcsbmmtf-cpparchiverefstagsv1.1.0.tar.gz"
    sha256 "021173bdc1814b1d0541c4426277d39df2b629af53151999b137e015418f76c0"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackages084c17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
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
    which("python3.12")
  end

  def install
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefixsite_packages

    resource("mmtf-cpp").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath"mmtf")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # install other resources
    resources.each do |r|
      next if r.name == "mmtf-cpp"

      r.stage do
        system python3, *Language::Python.setup_install_args(libexec, python3)
      end
    end

    if OS.linux?
      # Fixes "libxmlxmlwriter.h not found" on Linux
      ENV.append "LDFLAGS", "-L#{Formula["libxml2"].opt_lib}"
      ENV.append "CPPFLAGS", "-I#{Formula["libxml2"].opt_include}libxml2"
    end
    # CPPFLAGS freetype2 required.
    ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}freetype2"
    # Point to vendored mmtf headers.
    ENV.append "CPPFLAGS", "-I#{buildpath}mmtfinclude"

    args = %W[
      --install-scripts=#{libexec}bin
      --install-lib=#{libexecsite_packages}
      --glut
      --use-msgpackc=c++11
    ]

    system python3, "setup.py", "install", *args
    (prefixsite_packages"homebrew-pymol.pth").write libexecsite_packages
    bin.install libexec"binpymol"
  end

  def caveats
    "To generate movies, run `brew install ffmpeg`."
  end

  test do
    (testpath"test.py").write <<~EOS
      from pymol import cmd
      cmd.fragment('ala')
      cmd.zoom()
      cmd.png("test.png", 200, 200)
    EOS
    system "#{bin}pymol", "-cq", testpath"test.py"
    assert_predicate testpath"test.png", :exist?, "Amino acid image should exist"
    system python3, "-c", "import pymol"
  end
end