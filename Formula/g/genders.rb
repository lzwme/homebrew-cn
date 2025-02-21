class Genders < Formula
  desc "Static cluster configuration database for cluster management"
  homepage "https:github.comchaosgenders"
  url "https:github.comchaosgendersarchiverefstagsgenders-1-30-1.tar.gz"
  version "1.30.1"
  sha256 "6cbe717add68b45d27685fb9f324b5eb531da660ca22aa4430738b27c3e19bf2"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(^genders[._-]v?(\d+(?:[.-]\d+)+)$i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3dc6003d34054ca5fbd0798270fefd9255623536ad58f18a0e05a8d864337314"
    sha256 cellar: :any,                 arm64_sonoma:  "f26d79af42864c5576c9e7e59303f32403cc7611094df8595d2b0e4fddc1fd16"
    sha256 cellar: :any,                 arm64_ventura: "1ea15002ed41220dc87ac706e3495b545d7bd40e8ab7dbdf0342762138497998"
    sha256 cellar: :any,                 sonoma:        "20a7d3a16430a0d20425d688387d1b0cddf1706d254f8dade3dc8515b3c629da"
    sha256 cellar: :any,                 ventura:       "71a2a71c741ac16fe8d54345ff909917ad71b936899381896ae486cefa026837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18c1e118e576282e550f16e34d1ae820a7b5baf48b30efa5403106428ebc9389"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build

  # upstream issue to drop distutils usage, https:github.comchaosgendersissues65
  on_linux do
    depends_on "python-setuptools" => :build
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV["PYTHON"] = which("python3")

    system ".configure", "--with-java-extensions=no", *std_configure_args
    system "make", "install"

    # Move man page out of top level mandir on Linux
    man3.install (prefix"manman3").children unless OS.mac?
  end

  test do
    (testpath"cluster").write <<~EOS
      # slc cluster genders file
      slci,slcj,slc[0-15]  eth2=e%n,cluster=slc,all
      slci                 passwdhost
      slci,slcj            management
      slc[1-15]            compute
    EOS
    assert_match "0 parse errors discovered", shell_output("#{bin}nodeattr -f cluster -k 2>&1")
  end
end