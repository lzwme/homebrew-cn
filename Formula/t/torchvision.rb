class Torchvision < Formula
  include Language::Python::Virtualenv

  desc "Datasets, transforms, and models for computer vision"
  homepage "https:github.compytorchvision"
  url "https:github.compytorchvisionarchiverefstagsv0.16.0.tar.gz"
  sha256 "79b30b082237e3ead21e74587cedf4a4d832f977cf7dfeccfb65f67988b12ceb"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "580e45e7db2767939add1ab63e9c11eae8bebe25c6cbd7be80ffb89f189f2ea0"
    sha256 cellar: :any,                 arm64_ventura:  "9dd4898e77a2840016c29813a36ac706331bcb8101d23d5075f11d2c4b3802ca"
    sha256 cellar: :any,                 arm64_monterey: "6aecaf41d391502eabcd5e7fa1d8cd9e553d7683b9442d8ad4d27df00e33a747"
    sha256 cellar: :any,                 sonoma:         "ab5fa399c82f24a98fc0f422557fb73dc73327a379c35542c50d3fde89619f95"
    sha256 cellar: :any,                 ventura:        "6fc769801465390a70ab540aa5f43e01467c5e4ec16e004eae5cfa5b1e770b08"
    sha256 cellar: :any,                 monterey:       "3b649ca648bb8e94ef2f17398e54a91ea324909c537cf6e74d8d986009cb60e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "056a74c8bdd35b92ff4d1ed95e29a0b1bdda016693e896cf9a86fff5a40afb14"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python-certifi"
  depends_on "python-typing-extensions"
  depends_on "pytorch"

  on_macos do
    depends_on "libomp"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8b00db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    jpeg = Formula["jpeg-turbo"]
    inreplace "setup.py",
      "(jpeg_found, jpeg_conda, jpeg_include, jpeg_lib) = find_library(\"jpeglib\", vision_include)",
      "(jpeg_found, jpeg_conda, jpeg_include, jpeg_lib) = (True, False, \"#{jpeg.include}\", \"#{jpeg.lib}\")"

    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    # We depend on pytorch, but that's a separate formula, so install a `.pth` file to link them.
    # This needs to happen _before_ we try to install torchvision.
    site_packages = Language::Python.site_packages(python3)
    pytorch = Formula["pytorch"].opt_libexec
    (libexecsite_packages"homebrew-pytorch.pth").write pytorchsite_packages

    venv.pip_install_and_link(buildpath, build_isolation: false)

    pkgshare.install "examples"
  end

  test do
    # test that C++ libraries are available
    # See also https:github.compytorchvisionissues2134#issuecomment-1793846900
    (testpath"test.cpp").write <<~EOS
      #include <assert.h>
      #include <torchscript.h>
      #include <torchtorch.h>
      #include <torchvisionvision.h>
      #include <torchvisionopsnms.h>

      int main() {
        auto& ops = torch::jit::getAllOperatorsFor(torch::jit::Symbol::fromQualString("torchvision::nms"));
        assert(ops.size() == 1);
      }
    EOS
    pytorch = Formula["pytorch"]
    openmp_flags = if OS.mac?
      libomp = Formula["libomp"]
      %W[
        -Xpreprocessor -fopenmp
        -I#{libomp.opt_include}
        -L#{libomp.opt_lib} -lomp
      ]
    else
      %w[-fopenmp]
    end
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *openmp_flags,
                    "-I#{pytorch.opt_include}",
                    "-I#{pytorch.opt_include}torchcsrcapiinclude",
                    "-L#{pytorch.opt_lib}", "-ltorch", "-ltorch_cpu", "-lc10",
                    "-L#{lib}", *("-Wl,--no-as-needed" if OS.linux?), "-ltorchvision"

    system ".test"

    # test that the `torchvision` Python module is available
    cp test_fixtures("test.png"), "test.png"
    system libexec"binpython", "-c", <<~EOS
      import torch
      import torchvision
      t = torchvision.io.read_image("test.png")
      assert isinstance(t, torch.Tensor)
    EOS
  end
end