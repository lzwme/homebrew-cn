class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https:github.compypapipenv"
  url "https:files.pythonhosted.orgpackages5d334b7acd36a32189bbc7869cea88d68e55b900e723ba241faf506a884687f2pipenv-2024.0.2.tar.gz"
  sha256 "f4aca545b472e5ea00bd5131ef2b9047f509c420b89e998caa1085ed06d197cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee699f76dab9eb9ab1a58d483ac023a22ddda3384072c784ede17bf8a29b67b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee699f76dab9eb9ab1a58d483ac023a22ddda3384072c784ede17bf8a29b67b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee699f76dab9eb9ab1a58d483ac023a22ddda3384072c784ede17bf8a29b67b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f842c9622b7d653cab88f262dea347bc66e1269446819dd85f5b64ececdd75b"
    sha256 cellar: :any_skip_relocation, ventura:       "0f842c9622b7d653cab88f262dea347bc66e1269446819dd85f5b64ececdd75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "641866aebc292e2948b6d24fe69582c0ca19d2463b720e54e249605c2747d1b3"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackagese6763981447fd369539aba35797db99a8e2ff7ed01d9aa63e9344a31658b8d81filelock-3.16.0.tar.gz"
    sha256 "81de9eb8453c769b63369f87f11131a7ab04e367f8d97ad39dc230daa07e3bec"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages75a0d7cab8409cdc7d39b037c85ac46d92434fb6595432e069251b38e5c8dd0eplatformdirs-4.3.2.tar.gz"
    sha256 "9e5e27a08aa095dd127b9f2e764d74254f482fef22b0970773bfba79d091ab8c"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages3e2cf0a538a2f91ce633a78daaeb34cbfb93a54bd2132a6de1f6cec028eee6efsetuptools-74.1.2.tar.gz"
    sha256 "95b40ed940a1c67eb70fc099094bd6e99c6ee7c23aa2306f4d2697ba7916f9c6"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages848a134f65c3d6066153b84fc176c58877acd8165ed0b79a149ff50502597284virtualenv-20.26.4.tar.gz"
    sha256 "c17f4e0f3e6036e9f26700446f85c76ab11df65ff6d8a9cbfad9f71aabfcf23c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec"binpipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec"libpython*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output(bin"pipenv")
    system bin"pipenv", "--python", which(python3)
    system bin"pipenv", "install", "requests"
    system bin"pipenv", "install", "boto3"
    assert_predicate testpath"Pipfile", :exist?
    assert_predicate testpath"Pipfile.lock", :exist?
    assert_match "requests", (testpath"Pipfile").read
    assert_match "boto3", (testpath"Pipfile").read
  end
end