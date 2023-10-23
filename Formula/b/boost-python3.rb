class BoostPython3 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://ghproxy.com/https://github.com/boostorg/boost/releases/download/boost-1.83.0/boost-1.83.0.tar.xz"
  sha256 "c5a0688e1f0c05f354bbd0b32244d36085d9ffc9f932e8a18983a9908096f614"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3d877dd3a7fef04019b9abd09905c816c264837d4e0a1615b24780d1d858c053"
    sha256 cellar: :any,                 arm64_ventura:  "2b468394d24b854131ada0c428628cecaf20a9e05460f03c12178cbaaf0ea876"
    sha256 cellar: :any,                 arm64_monterey: "0160991f40341b7a7b0368b5032096c1316651827e591759f7339bed8cf649c1"
    sha256 cellar: :any,                 sonoma:         "70dd857783020599380618ce95cce3c8760592644577367d6a2623280c5d344c"
    sha256 cellar: :any,                 ventura:        "5a288da9ad53a8bf11014385c4c1cb67c0076eb7074485afc4a468354043cd59"
    sha256 cellar: :any,                 monterey:       "73f8e0b878568df1f22228acff8ea350fedf61e44ddd3930f9377ce250a9820d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c7f6ec979cb96b725e4c8d2badd78d50fc61276c4fe045f85ece077e8bf4593"
  end

  depends_on "numpy" => :build
  depends_on "boost"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    # "layout" should be synchronized with boost
    args = %W[
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged-1.66
      --user-config=user-config.jam
      install
      threading=multi,single
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    # disable python detection in bootstrap.sh; it guesses the wrong include
    # directory for Python 3 headers, so we configure python manually in
    # user-config.jam below.
    inreplace "bootstrap.sh", "using python", "#using python"

    pyver = Language::Python.major_minor_version python3
    py_prefix = if OS.mac?
      Formula["python@#{pyver}"].opt_frameworks/"Python.framework/Versions"/pyver
    else
      Formula["python@#{pyver}"].opt_prefix
    end

    # Force boost to compile with the desired compiler
    (buildpath/"user-config.jam").write <<~EOS
      using #{OS.mac? ? "darwin" : "gcc"} : : #{ENV.cxx} ;
      using python : #{pyver}
                   : #{python3}
                   : #{py_prefix}/include/python#{pyver}
                   : #{py_prefix}/lib ;
    EOS

    system "./bootstrap.sh", "--prefix=#{prefix}",
                             "--libdir=#{lib}",
                             "--with-libraries=python",
                             "--with-python=#{python3}",
                             "--with-python-root=#{py_prefix}"

    system "./b2", "--build-dir=build-python3",
                   "--stagedir=stage-python3",
                   "--libdir=install-python3/lib",
                   "--prefix=install-python3",
                   "python=#{pyver}",
                   *args

    lib.install buildpath.glob("install-python3/lib/*.*")
    (lib/"cmake").install buildpath.glob("install-python3/lib/cmake/boost_python*")
    (lib/"cmake").install buildpath.glob("install-python3/lib/cmake/boost_numpy*")
    doc.install (buildpath/"libs/python/doc").children
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <boost/python.hpp>
      char const* greet() {
        return "Hello, world!";
      }
      BOOST_PYTHON_MODULE(hello)
      {
        boost::python::def("greet", greet);
      }
    EOS

    pyincludes = shell_output("#{python3}-config --includes").chomp.split
    pylib = shell_output("#{python3}-config --ldflags --embed").chomp.split
    pyver = Language::Python.major_minor_version(python3).to_s.delete(".")

    system ENV.cxx, "-shared", "-fPIC", "hello.cpp", "-L#{lib}", "-lboost_python#{pyver}",
                    "-o", "hello.so", *pyincludes, *pylib

    output = <<~EOS
      import hello
      print(hello.greet())
    EOS
    assert_match "Hello, world!", pipe_output(python3, output, 0)
  end
end