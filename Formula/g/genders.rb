class Genders < Formula
  desc "Static cluster configuration database for cluster management"
  homepage "https:github.comchaosgenders"
  url "https:github.comchaosgendersarchiverefstagsgenders-1-31-1.tar.gz"
  version "1.31.1"
  sha256 "bb443a3c3b8b09a22d97550a997966cb9cd77ca47c24026393988702b07ffe07"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(^genders[._-]v?(\d+(?:[.-]\d+)+)$i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "08037b25160e755b0a73603e76a83002445a6472485b1e856b82788fbe0e46a2"
    sha256 cellar: :any,                 arm64_sonoma:  "a0dbc1f4c41b3bb42f8ed22afd2be19bdf5ab706ada683f1938dff14f4ed67d7"
    sha256 cellar: :any,                 arm64_ventura: "084206ecd3a25697c7758ffedcdedd132ba73df4fcc312a2d323c4ed397d1aa3"
    sha256 cellar: :any,                 sonoma:        "306fef11d5e6921048d027818a91388760030c062a345bca095424ed9a844bab"
    sha256 cellar: :any,                 ventura:       "528da84b44bc81f8041d8e51a4d5917d4f9198760e2170e9161a953f070be5e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc192e901b3cc085f303e2f61af4ef817a69e689ee03619835a9eaa189b8d852"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build

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

    ENV.append "CXXFLAGS", "-std=c++14"

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