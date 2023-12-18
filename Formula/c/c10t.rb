class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https:github.comudoprogc10t"
  url "https:github.comudoprogc10tarchiverefstags1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"
  license "BSD-3-Clause"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3bbd6fd6d50ef43f5397e84496db5cc8f6cf5302130de7956516d9cc8d37a199"
    sha256 cellar: :any,                 arm64_ventura:  "7306ba4a05eeb7969901d53d2ee18febbee1e9cc7463d89d945ff7eee34887c5"
    sha256 cellar: :any,                 arm64_monterey: "588e977a224a004d26dc7db65d188068351d083ea26295560de6f2da1d1147a3"
    sha256 cellar: :any,                 sonoma:         "e4f02c6b980a0a0e50570df5c4916b467a5d1da05462500f81642ab7e9b7cb02"
    sha256 cellar: :any,                 ventura:        "a7e87a9ac487a9cd60779974608732f5ddc86bc2afdeae0c79a385a1ac92cbf4"
    sha256 cellar: :any,                 monterey:       "75bd5a76ffc3a70274f1ba370ebb3d06d17c1a92589cc8e09d50bdd096b8436e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2edc116a10083ea04381986a30741553688507a84e935c4b5659dffe815f0ac9"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "freetype"

  # Needed to compile against newer boost
  # Can be removed for the next version of c10t after 1.7
  # See: https:github.comudoprogc10tpull153
  patch do
    url "https:github.comudoprogc10tcommit4a392b9f06d08c70290f4c7591e84ecdbc73d902.patch?full_index=1"
    sha256 "7197435e9384bf93f580fab01097be549c8c8f2c54a96ba4e2ae49a5d260e297"
  end

  # Fix freetype detection; adapted from this upstream commit:
  # https:github.comudoprogc10tcommit2a2b8e49d7ed4e51421cc71463c1c2404adc6ab1
  patch do
    url "https:gist.githubusercontent.commistydemeof7ab02089c43dd557ef4rawa0ae7974e635b8ebfd02e314cfca9aa8dc95029dc10t-freetype.diff"
    sha256 "9fbb7ccc643589ac1d648e105369e63c9220c26d22f7078a1f40b27080d05db4"
  end

  # Ensure zlib header is included for libpng; fixed upstream
  patch do
    url "https:github.comudoprogc10tcommit800977bb23e6b4f9da3ac850ac15dd216ece0cda.patch?full_index=1"
    sha256 "c7a37f866b42ff352bb58720ad6c672cde940e1b8ab79de4b6fa0be968b97b66"
  end

  def install
    ENV.cxx11
    inreplace "testCMakeLists.txt", "boost_unit_test_framework", "boost_unit_test_framework-mt"
    args = std_cmake_args
    unless OS.mac?
      args += %W[
        -DCMAKE_LINK_WHAT_YOU_USE=ON
        -DZLIB_LIBRARY=#{Formula["zlib"].opt_lib}libz.so.1
        -DZLIB_INCLUDE_DIR=#{Formula["zlib"].include}
      ]
    end
    system "cmake", ".", *args
    system "make"
    bin.install "c10t"
  end

  test do
    system "#{bin}c10t", "--list-colors"
  end
end