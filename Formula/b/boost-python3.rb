class BoostPython3 < Formula
  desc "C++ library for C++Python3 interoperability"
  homepage "https:www.boost.org"
  url "https:github.comboostorgboostreleasesdownloadboost-1.87.0boost-1.87.0-b2-nodocs.tar.xz"
  sha256 "3abd7a51118a5dd74673b25e0a3f0a4ab1752d8d618f4b8cea84a603aeecc680"
  license "BSL-1.0"
  head "https:github.comboostorgboost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7135ab567cd22e2b1d9aaabdc042b51a6d937f8e86d2a6aefdbd785cee788ec5"
    sha256 cellar: :any,                 arm64_sonoma:  "1da531ac175cff3144aa46d4495d12277874f75bed5fdb0e1598078e512c50e3"
    sha256 cellar: :any,                 arm64_ventura: "ec7a06c323a007a3d59c8256f8bb3ed0204e824a49199d3e1cf89d3f3baf3214"
    sha256 cellar: :any,                 sonoma:        "b04302f3858bb16f948950803b1a21935b44b64cd117278db309538d71c2ca8d"
    sha256 cellar: :any,                 ventura:       "b08e1448c9d173806e887c4f3a690a603d45bc4a071f3feadbca9b343e5617fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eefac2726cbea27f3934ced7e3f316aa7ef57af075eb182ffceac04941d50629"
  end

  depends_on "numpy" => :build
  depends_on "boost"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    # "layout" should be synchronized with boost
    args = %W[
      -d2
      -j#{ENV.make_jobs}
      --layout=system
      --user-config=user-config.jam
      install
      threading=multi
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    # Avoid linkage to boost container and graph modules
    # Issue ref: https:github.comboostorgboostissues985
    args << "linkflags=-Wl,-dead_strip_dylibs" if OS.mac?

    # disable python detection in bootstrap.sh; it guesses the wrong include
    # directory for Python 3 headers, so we configure python manually in
    # user-config.jam below.
    inreplace "bootstrap.sh", "using python", "#using python"

    pyver = Language::Python.major_minor_version python3
    py_prefix = if OS.mac?
      Formula["python@#{pyver}"].opt_frameworks"Python.frameworkVersions"pyver
    else
      Formula["python@#{pyver}"].opt_prefix
    end

    # Force boost to compile with the desired compiler
    (buildpath"user-config.jam").write <<~EOS
      using #{OS.mac? ? "darwin" : "gcc"} : : #{ENV.cxx} ;
      using python : #{pyver}
                   : #{python3}
                   : #{py_prefix}includepython#{pyver}
                   : #{py_prefix}lib ;
    EOS

    system ".bootstrap.sh", "--prefix=#{prefix}",
                             "--libdir=#{lib}",
                             "--with-libraries=python",
                             "--with-python=#{python3}",
                             "--with-python-root=#{py_prefix}"

    system ".b2", "--build-dir=build-python3",
                   "--stagedir=stage-python3",
                   "--libdir=install-python3lib",
                   "--prefix=install-python3",
                   "python=#{pyver}",
                   *args

    lib.install buildpath.glob("install-python3lib*{python,numpy}*")
    (lib"cmake").install buildpath.glob("install-python3libcmake*{python,numpy}*")
  end

  test do
    (testpath"hello.cpp").write <<~CPP
      #include <boostpython.hpp>
      char const* greet() {
        return "Hello, world!";
      }
      BOOST_PYTHON_MODULE(hello)
      {
        boost::python::def("greet", greet);
      }
    CPP

    pyincludes = shell_output("#{python3}-config --includes").chomp.split
    pylib = shell_output("#{python3}-config --ldflags --embed").chomp.split
    pyver = Language::Python.major_minor_version(python3).to_s.delete(".")

    system ENV.cxx, "-shared", "-fPIC", "-std=c++14", "hello.cpp", "-L#{lib}", "-lboost_python#{pyver}",
                    "-o", "hello.so", *pyincludes, *pylib

    output = <<~PYTHON
      import hello
      print(hello.greet())
    PYTHON
    assert_match "Hello, world!", pipe_output(python3, output, 0)
  end
end