class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://ghfast.top/https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.57.tar.gz"
  sha256 "db3b9c93dd54e0ff7edc461785b90506cdfb57feb78c8872bc0d00814cfba25d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d16e98dd57f3e1e6cbb40b2bd8f01a395360fba8638d97d632c468bd21b8420"
    sha256 cellar: :any,                 arm64_sonoma:  "2a8776513cf04767f22936e4b91f68cb899e55e0934fa6c9dcce4e819b916617"
    sha256 cellar: :any,                 arm64_ventura: "f3ee3422268beeb0fde633e58383c91a421fc2460fddee5a1a34ca35db03cd60"
    sha256 cellar: :any,                 sonoma:        "76d670639bd2edef9bc80a756e3ce9678aaf7573544b9f741069eded18e538ba"
    sha256 cellar: :any,                 ventura:       "01c63255f87cf3a8e5347db0d829e8dce8cb1b0b548ed2d5ae3328d4c68396c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae31173d5906ece0390bcf07324c373990af386712bd60c0fadcd107311da240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f68ea6a596f9f7575067ba4671caf9c8a265078200e7401c02ef0691e97d45"
  end

  depends_on "sdl2"
  depends_on "sdl2_image"

  on_linux do
    depends_on "vim" => :build # uses xxd
  end

  def install
    extra_flags = "-I#{HOMEBREW_PREFIX}/include/SDL2"
    system "make", "EXTRA_FLAGS=#{extra_flags}", "lilt"
    system "make", "EXTRA_FLAGS=#{extra_flags}", "decker"
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "examples"
  end

  test do
    assert_match '"depth":', shell_output("#{bin}/lilt #{pkgshare}/examples/lilt/mandel.lil")
  end
end