class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/90/5c/6a8d7074829d3bfe9496ea211625b4fcaf0a1f8a61ce72eacd87a0833a5d/pipenv-2023.7.4.tar.gz"
  sha256 "c737bf9da865036b87e53334872934907f1bf72d336f9b84eabd1297c6e3326e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85f42c133f6ed1adb297b69412a4629d2e303d548e0f7e1c0d69db3aa5047484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f9c30738822ce602ba82d8cc50f591caa70d437ff37aa6df018719e550e486c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e02b1cda71c73e74b6796d28e5143a8d061a47895b142d8eb5a370851c7b7a0"
    sha256 cellar: :any_skip_relocation, ventura:        "aec60ee60b76b7e206e7387835fa46756c2574e78941c66f970e6b7527898c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "b6300d42d0abce4f050562c7b5db7ae2efc6080e03c6b9c7ef0f3e0d06f32867"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f681fc61c3b306122e95f38f6a458bac3db2eab4319bddfa03760d4b922ab3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "824220ab74a1f81256ee69a5a3e7582522376da380f2dc5d66b777153ad8e54d"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cb/10/e5478cc0c3ee5563f91ab7b9da15d16e21f3737b6286ed3fd9a8fb1a99dd/platformdirs-3.8.0.tar.gz"
    sha256 "b0cabcb11063d21a0b261d557acb0a9d2126350e63b70cdf7db6347baea456dc"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/21/6b/0910aebe4d5c2a27d5a79ab8fae06d22f7e01dff46baf29ced8d080134c3/virtualenv-20.23.1.tar.gz"
    sha256 "8ff19a38c1021c742148edc4f81cb43d7f8c6816d2ede2ab72af5b84c749ade1"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def python3
    "python3.11"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pip", libexec/"bin/virtualenv"
    (bin/"pipenv").write_env_script libexec/"bin/pipenv", PATH: "#{libexec}/tools:${PATH}"

    generate_completions_from_executable(libexec/"bin/pipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "--python", which(python3)
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end