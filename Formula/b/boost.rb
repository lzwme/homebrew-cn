class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https:www.boost.org"
  url "https:github.comboostorgboostreleasesdownloadboost-1.87.0boost-1.87.0-b2-nodocs.tar.xz"
  sha256 "3abd7a51118a5dd74673b25e0a3f0a4ab1752d8d618f4b8cea84a603aeecc680"
  license "BSL-1.0"
  revision 1
  head "https:github.comboostorgboost.git", branch: "master"

  livecheck do
    url "https:www.boost.orgusersdownload"
    regex(href=.*?boost[._-]v?(\d+(?:[._]\d+)+)\.ti)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  bottle do
    sha256                               arm64_sequoia: "c827b28d0de5539243a36a04da69f1b67048647446b54cab341681855d222127"
    sha256                               arm64_sonoma:  "6fc5abc3c3fada8158a4a73da562d09c04e71a0c816d98a7474ba6d10d0c592f"
    sha256                               arm64_ventura: "6e81371cb46da9ec042933efb7425a8582c32fb67cd31e137611ff91351497d5"
    sha256 cellar: :any,                 sonoma:        "7f8992a5964f0400a706d39a81b58dd3698c2256476a7234c36dfe8b9d358606"
    sha256 cellar: :any,                 ventura:       "d2db29b27b0c7cd1e2ebd7119cad88973131406c6cce0345968be949a2f934a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a85d38911f532a83fba3707729b080f5d6ba29ffe366bd792d07f1413ac6954a"
  end

  depends_on "icu4c@77"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      if OS.mac?
        file.write "using darwin : : #{ENV.cxx} ;\n"
      else
        file.write "using gcc : : #{ENV.cxx} ;\n"
      end
    end

    # libdir should be set by --prefix but isn't
    icu4c = deps.map(&:to_formula).find { |f| f.name.match?(^icu4c@\d+$) }
    bootstrap_args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-icu=#{icu4c.opt_prefix}
    ]

    # Handle libraries that will not be built.
    without_libraries = ["python", "mpi"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bootstrap_args << "--without-libraries=#{without_libraries.join(",")}"

    # layout should be synchronized with boost-python and boost-mpi
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=system
      --user-config=user-config.jam
      install
      threading=multi
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++
    # handling in superenv. Using "cxxflags" and "linkflags" still works.
    # C++17 is due to `icu4c`.
    args << "cxxflags=-std=c++17"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    system ".bootstrap.sh", *bootstrap_args
    system ".b2", "headers"
    system ".b2", *args
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <boostalgorithmstring.hpp>
      #include <boostiostreamsdevicearray.hpp>
      #include <boostiostreamsdeviceback_inserter.hpp>
      #include <boostiostreamsfilterzstd.hpp>
      #include <boostiostreamsfiltering_stream.hpp>
      #include <boostiostreamsstream.hpp>

      #include <string>
      #include <iostream>
      #include <vector>
      #include <assert.h>

      using namespace boost::algorithm;
      using namespace boost::iostreams;
      using namespace std;

      int main()
      {
        string str("a,b");
        vector<string> strVec;
        split(strVec, str, is_any_of(","));
        assert(strVec.size()==2);
        assert(strVec[0]=="a");
        assert(strVec[1]=="b");

         Test boost::iostreams::zstd_compressor() linking
        std::vector<char> v;
        back_insert_device<std::vector<char>> snk{v};
        filtering_ostream os;
        os.push(zstd_compressor());
        os.push(snk);
        os << "Boost" << std::flush;
        os.pop();

        array_source src{v.data(), v.size()};
        filtering_istream is;
        is.push(zstd_decompressor());
        is.push(src);
        std::string s;
        is >> s;

        assert(s == "Boost");

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test", "-L#{lib}", "-lboost_iostreams",
                    "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system ".test"
  end
end