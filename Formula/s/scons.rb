class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/b9/76/a2c1293642f9a448f2d012cabf525be69ca5abf4af289bc0935ac1554ee8/scons-4.8.1.tar.gz"
  sha256 "5b641357904d2f56f7bfdbb37e165ab996b6143c948b9df0efc7305f54949daa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a328faf40ed543b4d70c679a181ab9aca15cf3c69cd4fd49f404a4f57c675825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "633b90cf71e96dd4958f27ec2dc6d38fea979e317edacf5d7423717957cc506a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "633b90cf71e96dd4958f27ec2dc6d38fea979e317edacf5d7423717957cc506a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "633b90cf71e96dd4958f27ec2dc6d38fea979e317edacf5d7423717957cc506a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a6fd9a6e51f29a80a45e60a7f85c750424fdf2e1f00627d2f3b416e8cd4b8a6"
    sha256 cellar: :any_skip_relocation, ventura:        "3a6fd9a6e51f29a80a45e60a7f85c750424fdf2e1f00627d2f3b416e8cd4b8a6"
    sha256 cellar: :any_skip_relocation, monterey:       "3a6fd9a6e51f29a80a45e60a7f85c750424fdf2e1f00627d2f3b416e8cd4b8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "633b90cf71e96dd4958f27ec2dc6d38fea979e317edacf5d7423717957cc506a"
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