class Pillow < Formula
  desc "Friendly PIL fork (Python Imaging Library)"
  homepage "https://python-pillow.org"
  url "https://files.pythonhosted.org/packages/64/9e/7e638579cce7dc346632f020914141a164a872be813481f058883ee8d421/Pillow-10.0.1.tar.gz"
  sha256 "d72967b06be9300fed5cfbc8b5bafceec48bf7cdc7dab66b1d2549035287191d"
  license "HPND"
  revision 1
  head "https://github.com/python-pillow/Pillow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a2275302c2d9182d74ac0069f4218744251049a80e3520a26c33adc14ff40a28"
    sha256 cellar: :any, arm64_ventura:  "26276c825a613fca195fc3e7b982d7170447a493df2115bc00ba3c92e7eee064"
    sha256 cellar: :any, arm64_monterey: "10ee58eed2a59cc2e48c3e12b306588a9ed9cd077860a9c43e1f3157e36bbee5"
    sha256 cellar: :any, sonoma:         "ff6abbdfdaf83fbdbd81ff52e9b16af2b9044ac8bd7970b2b891077243480659"
    sha256 cellar: :any, ventura:        "b9b40e13c3f77951e45897662d6427bf175db1416bf15cc99c5c54b0cd9cebeb"
    sha256 cellar: :any, monterey:       "451dad9c8693a9fcd31190cdbf77a8903e604ff8af05fc1e3b4bc8f91d8682b2"
    sha256               x86_64_linux:   "eaaf3b39e1254751aeaf720eca12ae9f6982d0df60cf790ee03e371303bdbae1"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
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
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
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
    (testpath/"test.py").write <<~EOS
      from PIL import Image
      im = Image.open("#{test_fixtures("test.jpg")}")
      print(im.format, im.size, im.mode)
    EOS

    pythons.each do |python|
      assert_equal "JPEG (1, 1) RGB", shell_output("#{python} test.py").chomp
    end
  end
end