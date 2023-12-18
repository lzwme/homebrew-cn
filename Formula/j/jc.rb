class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https:github.comkellyjonbraziljc"
  url "https:files.pythonhosted.orgpackages3bc1304d84db87ae7ccf439e6a9a3834ebc5531a98c92e1e7afbec32171ed11ejc-1.23.6.tar.gz"
  sha256 "886568b3819424235c60df7ebbc6cdee98c3eff7785d4b2ce5d78721035d444b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78c3eded6b2fa50b57610ae528186b9ba10376394c665d052f5a743fadbe4600"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25c1e7b1a6ad92425b4da3592637ef2d1e9441e5750909eca49acad434585b54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dc1ad582b4c05579a2e80b928778210fee0154ae4f30a3a24c6c8d999a9fe01"
    sha256 cellar: :any_skip_relocation, sonoma:         "329a3d272c228837621b2ae293bbdcd73404d03de5be12c655158af157ecc1d7"
    sha256 cellar: :any_skip_relocation, ventura:        "f52ad6182464912473ede2361db8e26e05d4be21a326b3cd3762e00b7978583e"
    sha256 cellar: :any_skip_relocation, monterey:       "c8273d188d6403de669c717ceabe680f41398342609d98cce8ecf86fdbcd7fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57320788ae0442bd1e694d2bc5da2b214947de2183a566755f89e93b3afb952e"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages0235456b8f54f1b33141bd6940ff021c914606e6b5e760e77f59cd19da096067ruamel.yaml-0.18.0.tar.gz"
    sha256 "8b0fc1c60575b6fc2c1ddff9381e422eb2c2d988fc2e3a138389f68cebe0a6f8"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "xmltodict" do
    url "https:files.pythonhosted.orgpackages390d40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7fxmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
    man1.install "manjc.1"
    generate_completions_from_executable(bin"jc", "--bash-comp", shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin"jc", "--zsh-comp", shells: [:zsh], shell_parameter_format: :none)
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n",
                  pipe_output("#{bin}jc --csv", "header1, header2\n data1, data2")
  end
end