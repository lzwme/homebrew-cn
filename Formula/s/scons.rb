class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/a4/ce/31e6d2f5e1d1cc23d65cfe4e28b2a83cc2d49f4bb99b5eec9240fb9a9857/SCons-4.6.0.tar.gz"
  sha256 "7db28958b188b800f803c287d0680cc3ac7c422ed0b1cf9895042c52567803ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bcbf2c4b50ee697e3cd1678bdfe1900dead825c3c286c74fa6a18051c19928a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5396c05832549e8464db6a6eee137b0bf485253fa919b1f1f6265359da3cc8f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6659091b103e9bae0c9792e063dec1b3543c707be6f0a46cc08e5ee77a9b1599"
    sha256 cellar: :any_skip_relocation, sonoma:         "101bf22a790f07825ffb59b099900af2e80f3e39d7c60d6a6df305bfd839ed06"
    sha256 cellar: :any_skip_relocation, ventura:        "14c2fc49d24cf38c241b3855031b06b0a58f5a73dbca235ddac9230c56008759"
    sha256 cellar: :any_skip_relocation, monterey:       "a28dae92355e10c12c0803c72d97440a302f7bd4efd1874401fbe2490a1cd655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "858e36218cd6e8ded5220619fd9afeaa2fdf76faa0e47ca06df7e9f4fc48cddc"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end