class Smake < Formula
  desc "Portable make program with automake features"
  homepage "https://s-make.sourceforge.net/"
  url "https://codeberg.org/schilytools/schilytools/archive/2023-04-19.tar.gz"
  version "1.7-2023-04-19"
  sha256 "a4270cdcca5dd69c0114079277b06e5efad260b0a099c9c09d31e16e99a23ff5"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55c37ff0fcdc4063d4d032dd8a2eecbd89993d7f72c1c78118dea2600dd906da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b91cff7c5ad2764b76ed32823d1d34c66caf9edb9573b0aceae67fc747e12c40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "993f7ba465c357fe4708e82d83ed5756ba3d99840057ec805193f5cc97360136"
    sha256 cellar: :any_skip_relocation, ventura:        "e2ca634976e6b65601812a0b47a3b8a3aeb1e03fac68d72a1c8f8ef8c84c997a"
    sha256 cellar: :any_skip_relocation, monterey:       "7146378cd1a1321496f23f8140f4dbbf325f4ed48d826fb0f87173607b220aa9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1029afbfea413385bcc1b9794e6c634e19b568ae2e922a542212098c4e20a934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "988c67994a34d30556d86182b63efee239863cc70dc4a645a3a265791ffa06af"
  end

  def install
    cd "psmake" do
      system "./MAKE-all"
    end

    cd "libschily" do
      system "../psmake/smake"
    end

    cd "smake" do
      system "../psmake/smake"
    end

    cd "man" do
      system "../psmake/smake"
    end

    bin.install Dir.glob("smake/OBJ/*/smake")
    man1.install Dir.glob("smake/OBJ/*/*/*.1")
    man5.install Dir.glob("man/man5/OBJ/*/*/*.5")
  end

  test do
    system "#{bin}/smake", "-version"
  end
end