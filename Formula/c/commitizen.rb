class Commitizen < Formula
  include Language::Python::Virtualenv

  desc "Defines a standard way of committing rules and communicating it"
  homepage "https:commitizen-tools.github.iocommitizen"
  url "https:files.pythonhosted.orgpackages60ca4335a56f2f9f1f95d1854ab7d3c485f47c87378db084b76c6e515d474231commitizen-4.0.0.tar.gz"
  sha256 "16aff27e01b43015eab1c74eabbca3e284b4988dd1b146a0963282db241dc2c0"
  license "MIT"
  head "https:github.comcommitizen-toolscommitizen.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe701bb95fa6971389b25387c213681536c6d6ed43e206e8810a38604f87a295"
    sha256 cellar: :any,                 arm64_sonoma:  "b62f11c05bd3b60e3353fef587a3717007ee9d9d344c878a79f0d806990bbb23"
    sha256 cellar: :any,                 arm64_ventura: "b92bff9b23ddf9a41b4f95295e71a0a0d7b82d81ad7105039e0821853cff65d3"
    sha256 cellar: :any,                 sonoma:        "8801bb81d7bdd3a85a7ee17ed07288f1c496eba767b2c7a0f0c5b7382eb33fb0"
    sha256 cellar: :any,                 ventura:       "7567649fae72cc0981d1dabaf8792fd97f8c500a4e505dac4f38aeed146b36d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "320aab191258705ba0e8d88da1b82a32e516472df7863a92b70a3f07603065d2"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages5f3927605e133e7f4bb0c8e48c9a6b87101515e3446003e0442761f6a02ac35eargcomplete-3.5.1.tar.gz"
    sha256 "eb1ee355aa2557bd3d0145de7b06b2a45b0ce461e1e7813f5d066039ab4177b4"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decli" do
    url "https:files.pythonhosted.orgpackages3da0a4658f93ecb589f479037b164dc13c68d108b50bf6594e54c820749f97acdecli-0.6.2.tar.gz"
    sha256 "36f71eb55fd0093895efb4f416ec32b7f6e00147dda448e3365cf73ceab42d6f"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesfb93180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "questionary" do
    url "https:files.pythonhosted.orgpackages84d0d73525aeba800df7030ac187d09c59dc40df1c878b4fab8669bdc805535dquestionary-2.0.1.tar.gz"
    sha256 "bcce898bf3dbb446ff62830c86c5c6fb9a22a54146f0f5597d3da43b10d8fc8b"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackages377288311445fd44c455c7d553e61f95412cf89054308a1aa2434ab835075fc5termcolor-2.5.0.tar.gz"
    sha256 "998d8d27da6d48442e8e1f016119076b690d962507531df4890fcd2db2ef8a6f"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesb109a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fatomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(
      libexec"binregister-python-argcomplete", "cz",
      base_name:              "cz",
      shell_parameter_format: :arg
    )
  end

  test do
    # Generates a changelog after an example commit
    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "yes | #{bin}cz commit"
    system bin"cz", "changelog"

    # Verifies the checksum of the changelog
    expected_sha = "97da642d3cb254dbfea23a9405fb2b214f7788c8ef0c987bc0cde83cca46f075"
    output = File.read(testpath"CHANGELOG.md")
    assert_match Digest::SHA256.hexdigest(output), expected_sha
  end
end