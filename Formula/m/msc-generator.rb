class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://gitlab.com/msc-generator/msc-generator"
  url "https://gitlab.com/api/v4/projects/31167732/packages/generic/msc-generator/8.5/msc-generator-8.5.tar.gz"
  sha256 "134da30f58458a5ddda0cf6c7a43872636dfc6cae1b8e8a02efe28a0cc9f35d3"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://gitlab.com/api/v4/projects/31167732/packages"
    strategy :json do |json|
      json.map do |item|
        next unless item["name"]&.downcase&.include?("msc-generator")

        item["version"]
      end
    end
  end

  bottle do
    sha256 arm64_sonoma:   "3e00d902a9026a506a377cb60f65907637cb9a1b504f43e5ab0d5a14d67829e4"
    sha256 arm64_ventura:  "28372cf91533d742b97596987183c7bb4562bdd76ab37980c87f5c79d216bcd5"
    sha256 arm64_monterey: "51e156b15fabca3b08b0a0d562e4e99f0a8169da43aa3ab7b1454b757ef3c4fe"
    sha256 sonoma:         "0d8be9dcfa13b600ac491923d6be8cfae52abc444e413d6e7d685b24f2e12d71"
    sha256 ventura:        "2f8407084c53d6b96fa290276baa62a9aa32375e44dad20479e83ca8caaf0551"
    sha256 monterey:       "8bdd66e2db21a4494338a802bfd943c6a48903e3ab870a5fafc929c4217847b8"
    sha256 x86_64_linux:   "45f0d45aa644eeffaae8657987a7c21ad2fb14826ceff341d319072ba45ec46c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glpk"
  depends_on "graphviz"
  depends_on "sdl2"
  depends_on "tinyxml2"

  on_macos do
    # Some upstream sed discussions in https://gitlab.com/msc-generator/msc-generator/-/issues/92
    depends_on "gnu-sed" => :build
    depends_on "make" => :build # needs make 4.3+
    depends_on "gcc"
  end

  on_linux do
    depends_on "mesa"
  end

  fails_with :clang # needs std::range

  fails_with :gcc do
    version "9"
    cause "needs std::range"
  end

  def install
    args = %w[--disable-font-checks --disable-silent-rules]
    make = "make"

    # Brew uses shims to ensure that the project is built with a single compiler.
    # However, gcc cannot compile our Objective-C++ sources (clipboard.mm), while
    # clang++ cannot compile the rest of the project. As a workaround, we set gcc
    # as the main compiler, and bypass brew's compiler shim to force using clang++
    # for Objective-C++ sources. This workaround should be removed once brew supports
    # setting separate compilers for C/C++ and Objective-C/C++.
    if OS.mac?
      args << "OBJCXX=/usr/bin/clang++"
      ENV.append_to_cflags "-DNDEBUG"
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      ENV["MAKE"] = make = "gmake"
    end

    system "./configure", *args, *std_configure_args
    system make, "-C", "src", "install"
    system make, "-C", "doc", "msc-gen.1"
    man1.install "doc/msc-gen.1"
  end

  test do
    # Try running the program
    system "#{bin}/msc-gen", "--version"
    # Construct a simple chart and check if PNG is generated (the default output format)
    (testpath/"simple.signalling").write("a->b;")
    system "#{bin}/msc-gen", "simple.signalling"
    assert_predicate testpath/"simple.png", :exist?
    bytes = File.binread(testpath/"simple.png")
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end