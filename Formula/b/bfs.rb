class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https:tavianator.comprojectsbfs.html"
  url "https:github.comtavianatorbfsarchiverefstags3.1.tar.gz"
  sha256 "aa6a94231915d3d37e5dd62d194cb58a575a8f45270020f2bdd5ab41e31d1492"
  license "0BSD"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b929a4fb67b4b5c3d01d49ade4904d87ade523d0fb10894920046733c8ae510"
    sha256 cellar: :any,                 arm64_ventura:  "86e34bcff48e8c0308a81cfbe654ccefe08142e86746168a11c2bfbe25dba250"
    sha256 cellar: :any,                 arm64_monterey: "3be22c82737b2002b6e107a1c45b28d53bb16e43c9659b82576b58c037627985"
    sha256 cellar: :any,                 sonoma:         "1f4cbe282c30fd26f6bc415a90f798a59e192dea912fbf2933d7f7dda0005607"
    sha256 cellar: :any,                 ventura:        "10d15204451d16a61793401651b0bada84fe2cf960b874e508954504b349a490"
    sha256 cellar: :any,                 monterey:       "edc57b7426f6dcef201233de363267001d99ab0b0765e0e8acb395bcfb03935c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d6b684cc66f17538503f6689ffe3af0a5e48972d427bd1b98045b425ccaa5e"
  end

  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
    depends_on "liburing"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    system "make", "release"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal ".test_file", shell_output("#{bin}bfs -name 'test*' -depth 1").chomp
  end
end