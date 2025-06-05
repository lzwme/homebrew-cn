class Chipmunk < Formula
  desc "2D rigid body physics library written in C"
  homepage "https:chipmunk-physics.net"
  url "https:chipmunk-physics.netreleaseChipmunk-7.xChipmunk-7.0.3.tgz"
  mirror "https:www.mirrorservice.orgsitesdistfiles.macports.orgchipmunkChipmunk-7.0.3.tgz"
  sha256 "048b0c9eff91c27bab8a54c65ad348cebd5a982ac56978e8f63667afbb63491a"
  license "MIT"
  head "https:github.comslembckeChipmunk2D.git", branch: "master"

  livecheck do
    url "https:chipmunk-physics.netdownloads.php"
    regex(>\s*Chipmunk2D\s+v?(\d+(?:\.\d+)+)\s*<i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "97effc6e461bf5caddcf2b7c219b694f45468cae26870becc75f66e5d1c89076"
    sha256 cellar: :any,                 arm64_sonoma:   "da4db92c9a17fdc20990b5e994a3034c89506fe0ce2800275bcfeb128be6d1e8"
    sha256 cellar: :any,                 arm64_ventura:  "41cbccebde6b4a35fe046c12cef11eafa6e5ed1e096837a490ca4c6d0bc67a9d"
    sha256 cellar: :any,                 arm64_monterey: "544c8185e3366a6b067ad4cafb6272610014f0b5787b0c35a735b2c6bc3c7588"
    sha256 cellar: :any,                 arm64_big_sur:  "53a1d8968efd45940eda303182f7a68be0e31221295a85e803f92f3c968c45ad"
    sha256 cellar: :any,                 sonoma:         "fb790ab6526b620db57b8c0ed76203581a16a4b4062a9c33deb508d6cfc11bbd"
    sha256 cellar: :any,                 ventura:        "17ce597c5e951cc1bf44ef919c282862d891ec3ea6129714130d3f9dd4af51b4"
    sha256 cellar: :any,                 monterey:       "a404cce4a0aa17f7f4a0645c38ecc7b318a8fa1576d1168b5e4db40a51de9c12"
    sha256 cellar: :any,                 big_sur:        "6f68cb2c7dfecb8ef8b4572257ce7dd86d3de49af8c6073b173996020132902f"
    sha256 cellar: :any,                 catalina:       "b71191c2c1e4859cb9d5e77b8684612dec1c191780a0b1d56afc04ada66da036"
    sha256 cellar: :any,                 mojave:         "16292e5518bae60c6990a6f1565e1416f91ffe1c878ab43b58465bb2a24d3d11"
    sha256 cellar: :any,                 high_sierra:    "5370b9d8db489d6b8944c23fd4906768c84d87e22f054ca3381c7ee527233f4d"
    sha256 cellar: :any,                 sierra:         "c92a9c1134a272244ca3936b2c94431df7ed7002a9eec99f6914fe1128adae12"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "857cbad68b4a02449610842ae6abc4f1ecd573a4f06f286b7880e2906cb353c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe06ebff94b32562d036af4c9e34edb95a32fc4bdae48b846b1f21702441dfe2"
  end

  depends_on "cmake" => :build

  def install
    inreplace "srccpHastySpace.c", "#include <syssysctl.h>", "#include <linuxsysctl.h>" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_DEMOS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install Dir["doc*"]
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include <chipmunk.h>

      int main(void){
        cpVect gravity = cpv(0, -100);
        cpSpace *space = cpSpaceNew();
        cpSpaceSetGravity(space, gravity);

        cpSpaceFree(space);
        return 0;
      }
    C
    system ENV.cc, testpath"test.c", "-o", testpath"test", "-pthread",
                   "-I#{include}chipmunk", "-L#{lib}", "-lchipmunk"
    system ".test"
  end
end