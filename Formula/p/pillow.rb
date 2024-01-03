class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https:python-pillow.org"
  url "https:files.pythonhosted.orgpackagesf83e32cbd0129a28686621434cbf17bb64bf1458bfb838f1f668262fefce145cpillow-10.2.0.tar.gz"
  sha256 "e87f0b2c78157e12d7686b27d63c070fd65d994e8ddae6f328e0dcf4a0cd007e"
  license "HPND"
  head "https:github.compython-pillowPillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d78150b52727bc938220d1beddeb5441a14bfdec51f7588bfcebd2dafa822e0b"
    sha256 cellar: :any, arm64_ventura:  "18f47dae82234443c1d1b286ad5c02d7b390e17fbd115f0e091354025ab7836d"
    sha256 cellar: :any, arm64_monterey: "9e8a400361e062d2d37a523a616b5cb658455b1182efb7638acb634db56d386d"
    sha256 cellar: :any, sonoma:         "abc65522ca88a66f0ea8d29ab6be48de1d4480fd1b724a00ad2815c7b160e377"
    sha256 cellar: :any, ventura:        "fecd230bfe50232aff381727ce9f61813bb056f8d86d32474fd11d026635638f"
    sha256 cellar: :any, monterey:       "44521f9d3b49bf3b16a5f571e294c76bb2ce76cf30970d18affaecdd2c0668e1"
    sha256               x86_64_linux:   "9e0abc79f3e65ccf581ea99284c3edcab965ee794ad8607a408fded7814c0d1c"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "jpeg-turbo"
  depends_on "libimagequant"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "libxcb"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "tcl-tk"
  depends_on "webp"

  uses_from_macos "zlib"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(^python@\d\.\d+$) }
        .map { |f| f.opt_libexec"binpython" }
  end

  def install
    ENV["MAX_CONCURRENCY"] = ENV.make_jobs.to_s
    deps.each do |dep|
      next if dep.build? || dep.test?

      ENV.prepend "CPPFLAGS", "-I#{dep.to_formula.opt_include}"
      ENV.prepend "LDFLAGS", "-L#{dep.to_formula.opt_lib}"
    end

    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args,
                     "-C", "debug=true", # Useful in case of build failures.
                     "-C", "tiff=enable",
                     "-C", "freetype=enable",
                     "-C", "lcms=enable",
                     "-C", "webp=enable",
                     "-C", "xcb=enable",
                     "."
    end
  end

  test do
    (testpath"test.py").write <<~EOS
      from PIL import Image
      im = Image.open("#{test_fixtures("test.jpg")}")
      print(im.format, im.size, im.mode)
    EOS

    pythons.each do |python|
      assert_equal "JPEG (1, 1) RGB", shell_output("#{python} test.py").chomp
    end
  end
end