class Pymol < Formula
  include Language::Python::Virtualenv
  desc "Molecular visualization system"
  homepage "https:pymol.org"
  url "https:github.comschrodingerpymol-open-sourcearchiverefstagsv2.5.0.tar.gz"
  sha256 "aa828bf5719bd9a14510118a93182a6e0cadc03a574ba1e327e1e9780a0e80b3"
  license :cannot_represent
  head "https:github.comschrodingerpymol-open-source.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "1b3edf37eaeb5b3c38e5fdf9f6a72f4eafecb1f4ea0bb7a9208b0a4e41202a1f"
    sha256 cellar: :any,                 arm64_ventura:  "33fb5ec69774436e99803273fe04c69ec04d4af245361b3ef916141e867c0b08"
    sha256 cellar: :any,                 arm64_monterey: "e2c6c18ea8a6643a96692e427d31b33cf21003c30ec74fadc8aa019b20e881d0"
    sha256 cellar: :any,                 sonoma:         "0d8fa8d46524c5c87123860a1fa0641a1ed0390ab6b2230301f055ad95e8a6a7"
    sha256 cellar: :any,                 ventura:        "2172933239097915902897e01cbef8bf505aa80ec88cc9c1a8028c48de982aed"
    sha256 cellar: :any,                 monterey:       "e9580cbfe839e0ed7cc37d13982ac6928684ff8baf426fc9b23bd2a1ec668290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ecb4cb75a88e52dcdbced60b2bd41dddf14bb5c3671e23737b5b20e6ae4a1a2"
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
    url "https:github.comrcsbmmtf-cpparchiverefstagsv1.0.0.tar.gz"
    sha256 "881f69c4bb56605fa63fd5ca50842facc4947f686cbf678ad04930674d714f40"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackages613c2206f39880d38ca7ad8ac1b28d2d5ca81632d163b2d68ef90e46409ca057msgpack-1.0.3.tar.gz"
    sha256 "51fdc7fb93615286428ee7758cecc2f374d5ff363bdd884c7ea622a7a327a81e"
  end

  resource "mmtf-python" do
    url "https:files.pythonhosted.orgpackages13eac6a302ccdfdcc1ab200bd2b7561e574329055d2974b1fb7939a7aa374da3mmtf-python-1.1.2.tar.gz"
    sha256 "a5caa7fcd2c1eaa16638b5b1da2d3276cbd3ed3513f0c2322957912003b6a8df"
  end

  resource "Pmw" do
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