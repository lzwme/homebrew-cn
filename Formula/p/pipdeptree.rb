class Pipdeptree < Formula
  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https:github.comtox-devpipdeptree"
  url "https:files.pythonhosted.orgpackagesb582127215bd6bf6f1c0d98c89052eb91c67e34258b743395e3ebd24bc7a3816pipdeptree-2.13.1.tar.gz"
  sha256 "1e1acdb2ddc2abdca1718f27ca8dc21622c896a00b8980ec3d42c2208a841a10"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7649af49c69604fe8904d548d5360d30d6a8399a219cc79910c875d9f53d575f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5620b3cca350a60944675835e8363c54f3a2e66cce9634fff98886d6dde86fa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee3b2793f797f18daf5998723cd6c8922688c5ee1636138f5eac06a14b4f12f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "73586004e3a919a145bf1bf37f009f7bc390952b0f29af1da114c0f00d48a37a"
    sha256 cellar: :any_skip_relocation, ventura:        "9263ade92010b35830d84bcbad4b65f235fc522a2d590ad91c6dc0aa22588967"
    sha256 cellar: :any_skip_relocation, monterey:       "67121585e3b8569e9cf8c1a0a785a58f72cd82c88e44d651fd4a308409e2cf91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7da8fe471a81d7766d5664990e17fa0c2aa9b426e6b1d4def6bb3743997b549"
  end

  depends_on "python-hatch-vcs" => :build
  depends_on "python-hatchling" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-setuptools-scm" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}pipdeptree --all")

    assert_empty shell_output("#{bin}pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}pipdeptree --version").strip
  end
end