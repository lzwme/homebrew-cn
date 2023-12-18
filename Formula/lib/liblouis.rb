class Liblouis < Formula
  desc "Open-source braille translator and back-translator"
  homepage "https:liblouis.io"
  url "https:github.comliblouisliblouisreleasesdownloadv3.28.0liblouis-3.28.0.tar.gz"
  sha256 "69eddef2cf2118748a1d548cab3671ba31140c37dd821a2d893d95bc2796e1b0"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 arm64_sonoma:   "e0c94db46779ebf8b5479e5ea1b01ce375de928e69c06c21b163e8bd1506116a"
    sha256 arm64_ventura:  "f7c1672b2c0aa5463ec5dab18e77cda9cf8cc15e0618f9e1425c8807a86082b3"
    sha256 arm64_monterey: "bbe4303bfc9ac0d9b04e2ee18b7eaac9473287d95713be459873fc9cf3384f95"
    sha256 sonoma:         "304d531fd215bffd9977de111d567cfd14f2498ded8603d98e2e9c6b582809df"
    sha256 ventura:        "6c4396e3849c9cfaa736b297cb93a5051a6ccb6e548f7671732fb37dc2e75de0"
    sha256 monterey:       "aa7e813e8bfdc08da8f3a1dd68d4b92abe74db4616a92755a833c35e6673c316"
    sha256 x86_64_linux:   "b712e8e7dd52a22583a4a2f170a97a3f77a2d4408e7ffbffc3d63167a21d14f1"
  end

  head do
    url "https:github.comliblouisliblouis.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system ".autogen.sh" if build.head?
    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "check"
    system "make", "install"
    system python3, "-m", "pip", "install", *std_pip_args, ".python"
    (prefix"tools").install bin"lou_maketable", bin"lou_maketable.d"
  end

  test do
    assert_equal "⠼⠙⠃", pipe_output("#{bin}lou_translate unicode.dis,en-us-g2.ctb", "42")

    (testpath"test.py").write <<~EOS
      import louis
      print(louis.translateString(["unicode.dis", "en-us-g2.ctb"], "42"))
    EOS
    assert_equal "⠼⠙⠃", shell_output("#{python3} test.py").chomp
  end
end