class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https:github.compypapipenv"
  url "https:files.pythonhosted.orgpackages081ed8e3b937de28491a887683600d6496b05c10a5e0693ec703f3c89638ea66pipenv-2023.11.15.tar.gz"
  sha256 "f587ffff47e8aa76f17803d571f64cf5a24b2bdfb9334435e6528b22ad5e304f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77fce9c9831b9c85d2aebc71780dbf02bf23c2e35b8f3f33cae496e8625d09f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "821f8bdbc29d3349dbd96a1d6754009bd408a91ef3c896276c141a5743bc1299"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9899bab182da48bdec9d48940f5092ee1b05494b7a5ba149ef5aba79c7db69e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9350f910cbf792ac3652a91b4206f56451155857383bb907f9821022f7ccc467"
    sha256 cellar: :any_skip_relocation, ventura:        "2ba365bcee71916edc4d4af1eb234176cb08a0b64c67657c979f756f7af6e7cd"
    sha256 cellar: :any_skip_relocation, monterey:       "9a3a340866f56b07604bef81ae96ad4a8082194ccc756900eed4b2fcb6ac657f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6841de3f89402d20799752e099b906d126862d7950ea619c56ef80ef1593df27"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "virtualenv"

  def python3
    "python3.12"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages707041905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages62d17feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9aplatformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesfcc9b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages94d7adb787076e65dc99ef057e0118e25becf80dd05233ef4c86f07aa35f6492virtualenv-20.25.0.tar.gz"
    sha256 "bf51c0d9c7dd63ea8e44086fa1e4fb1093a31e963b86959257378aef020e1f1b"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[virtualenv].map { |p| Formula[p].opt_libexecsite_packages }
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")

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
    assert_match "Commands", shell_output("#{bin}pipenv")
    system "#{bin}pipenv", "--python", which(python3)
    system "#{bin}pipenv", "install", "requests"
    system "#{bin}pipenv", "install", "boto3"
    assert_predicate testpath"Pipfile", :exist?
    assert_predicate testpath"Pipfile.lock", :exist?
    assert_match "requests", (testpath"Pipfile").read
    assert_match "boto3", (testpath"Pipfile").read
  end
end