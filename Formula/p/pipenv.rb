class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/d8/6c/41efe0b9417023d460049c881aae5860f37a0018b52dcd4d954bc5a57ea2/pipenv-2026.0.2.tar.gz"
  sha256 "19aa881e98513852c5133ac5a2d898d2546654d062f7f524ed8e0f8f222c98b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c06049e2382591c74ac13df3fbc11bd47658f93c7f8059f39fdd3b355cf5c49b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c06049e2382591c74ac13df3fbc11bd47658f93c7f8059f39fdd3b355cf5c49b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c06049e2382591c74ac13df3fbc11bd47658f93c7f8059f39fdd3b355cf5c49b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4ea1c144c8f7ac3cffa1ed9e68adb3b6db041c9a814de8e932bde718b109969"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4ea1c144c8f7ac3cffa1ed9e68adb3b6db041c9a814de8e932bde718b109969"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4ea1c144c8f7ac3cffa1ed9e68adb3b6db041c9a814de8e932bde718b109969"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  def python3
    "python3.14"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/20/28/e6f1a6f655d620846bd9df527390ecc26b3805a0c5989048c210e22c5ca9/virtualenv-20.35.4.tar.gz"
    sha256 "643d3914d73d3eeb0c552cbb12d7e82adf0e504dbf86a3182f8771a153a1971c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/pipenv", shell_parameter_format: :click)
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
    assert_match "Commands", shell_output(bin/"pipenv")
    system bin/"pipenv", "--python", which(python3)
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_path_exists testpath/"Pipfile"
    assert_path_exists testpath/"Pipfile.lock"
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end