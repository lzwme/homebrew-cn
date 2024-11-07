class Tinyxml < Formula
  desc "XML parser"
  homepage "http:www.grinninglizard.comtinyxml"
  url "https:downloads.sourceforge.netprojecttinyxmltinyxml2.6.2tinyxml_2_6_2.tar.gz"
  sha256 "15bdfdcec58a7da30adc87ac2b078e4417dbe5392f3afb719f9ba6d062645593"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d9865bd3033992b304259880d063f35dd08c314ecf0f3a627a6dda616e946b8b"
    sha256 cellar: :any,                 arm64_sonoma:   "bc5be45bfaaab1e89a96c0fba01f026586cfd831d067a5a534b3c72de7026f83"
    sha256 cellar: :any,                 arm64_ventura:  "5ce481b9f659d845c681b7b88daac645064e622d9e3f93710f35ecc58821a4cf"
    sha256 cellar: :any,                 arm64_monterey: "aaed7baf7452fd109d0fd56329e123f22aa9cef10e03457be3c264558d2d48bc"
    sha256 cellar: :any,                 arm64_big_sur:  "04fccb4076db86eb901b710f5d50b01ea6e6cec907979aed5eb5135c9654e16d"
    sha256 cellar: :any,                 sonoma:         "411be9ab2a72b062658be8540ca60f4e7df5b8cdf87d8d08717828d5265c89ce"
    sha256 cellar: :any,                 ventura:        "36c60c1b48773714de769e0cf8f29601304c28e83c04469d10a9230cd46fd132"
    sha256 cellar: :any,                 monterey:       "ab27b95104332e68e5bda836a4044b972add1033f8dc9622472a7b9682eceed3"
    sha256 cellar: :any,                 big_sur:        "e98aaca0d889c322b5e2294495e7613e656773fb5f605a6239d8b85949011b99"
    sha256 cellar: :any,                 catalina:       "7cc1ada5d273bec9f50a1809a9989306ec9601a037c06b362cee321fbdc5c0a7"
    sha256 cellar: :any,                 mojave:         "c1fc1d7fa9e6934412294e921cde90bcfd107b68dbdddd9acf8cae4927190718"
    sha256 cellar: :any,                 high_sierra:    "ec0f83018a9ff93c11b6a8c92483056b2771359a14aedfb6dc46e1ab078ce9ac"
    sha256 cellar: :any,                 sierra:         "ef8c7bbbae6148e161b6f3369ede8bd3533a32847dc716000b46d26e6fb1c26c"
    sha256 cellar: :any,                 el_capitan:     "16e6052892b43e68c45f5122b6802e9bc32001dc9478dfcd89511a24544660e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ade5525899de7063ade79d1b0dec70ceef3d0acc08e1dc1b55e937cb539ad38d"
  end

  depends_on "cmake" => :build

  # The first two patches are taken from the debian packaging of tinyxml.
  #   The first patch enforces use of stl strings, rather than a custom string type.
  #   The second patch is a fix for incorrect encoding of elements with special characters
  #   originally posted at https:sourceforge.netptinyxmlpatches51
  # The third patch adds a CMakeLists.txt file to build a shared library and provide an install target
  #   submitted upstream as https:sourceforge.netptinyxmlpatches66
  patch do
    url "https:raw.githubusercontent.comrobotologyyarp59eedfbaa1069aa5f03a4a9980d984d59decd55cexterntinyxmlpatchesenforce-use-stl.patch"
    sha256 "16a5b5e842eb0336be606131e5fb12a9165970f7bd943780ba09df2e1e8b29b1"
  end

  patch do
    url "https:raw.githubusercontent.comrobotologyyarp59eedfbaa1069aa5f03a4a9980d984d59decd55cexterntinyxmlpatchesentity-encoding.patch"
    sha256 "c5128e03933cd2e22eb85554d58f615f4dbc9177bd144cae2913c0bd7b140c2b"
  end

  patch do
    url "https:gist.githubusercontent.comscpeters6325123rawcfb079be67997cb19a1aee60449714a1dedefed5tinyxml_CMakeLists.patch"
    sha256 "32160135c27dc9fb7f7b8fb6cf0bf875a727861db9a07cf44535d39770b1e3c7"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (lib+"pkgconfigtinyxml.pc").write pc_file
  end

  def pc_file
    <<~EOS
      prefix=#{opt_prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}lib
      includedir=${prefix}include

      Name: TinyXml
      Description: Simple, small, C++ XML parser
      Version: #{version}
      Libs: -L${libdir} -ltinyxml
      Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath"test.xml").write <<~XML
      <?xml version="1.0" ?>
      <Hello>World<Hello>
    XML
    (testpath"test.cpp").write <<~CPP
      #include <tinyxml.h>

      int main()
      {
        TiXmlDocument doc ("test.xml");
        doc.LoadFile();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltinyxml", "-o", "test"
    system ".test"
  end
end