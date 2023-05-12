class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/b0/60/af20fcbf3cab57b63c5bad2ef25a037ade8af5084635b42d371189286316/pipdeptree-2.7.1.tar.gz"
  sha256 "550bd7679379e7290739384f3e9518835620e814cc29ba709513952b627da506"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ac19f21a217ccc4265ec2633fe253b247fc59934f837bea18557a3d40e769f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea70834a2006cd6c95228864f87c4d10acf9aacaeeb2192a0eb456378fbcf07c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "043dafb42a7b8d63e24dd2007f2146218f07802b6137f1d3525ce5a933bb6a5a"
    sha256 cellar: :any_skip_relocation, ventura:        "5011233465738f687c73c1d53cc385ea7cde5449e3fb80730b69fb377ea50aa7"
    sha256 cellar: :any_skip_relocation, monterey:       "97a6999911a2ee50babd7b9559c9b677047ec82d76ee061a53ac4aa61abceaaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "fefd80438a8a5466ef0c543e2484b1ded238e384e4ee62f37980094d30b889a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e03ae0a7f274b4c17785a7d65e8170237e41380b9513957f8371c79b6e3e0a56"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end