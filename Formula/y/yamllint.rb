class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https:github.comadrienvergeyamllint"
  url "https:files.pythonhosted.orgpackagesccb6d17e75cc0b1b0a93cb04bb0b350c6ab10f48271f35897849c5d136b7a037yamllint-1.36.0.tar.gz"
  sha256 "3835a65994858679ea06fd998dd968c3f71935cd93742990405999d888e21130"
  license "GPL-3.0-or-later"
  head "https:github.comadrienvergeyamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4f9a506570cecc0addc1076714ac339bb67af57ba252d8f30475930acb83b154"
    sha256 cellar: :any,                 arm64_sonoma:  "8168715104079553284e3f30ce04d73fff05b8b01732221b3d767cfdb2113fcc"
    sha256 cellar: :any,                 arm64_ventura: "c897f2a97134743b7e1572b577312b414fce087c0e46b4101d2502c4fa91b618"
    sha256 cellar: :any,                 sonoma:        "7dc2ee95d7fc2d82fda7939cb37afd6bab9f7ea69894a6e6767439eabdff5d35"
    sha256 cellar: :any,                 ventura:       "3ae0668a20d7dc39bd33d29d5f07f5e5d756c5de27162d692cafdc9012163584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3afca6d3c399ad14916ddfd9e1f6e5621d4139aacc681c0471fc2b36541f0c7f"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"bad.yaml").write <<~YAML
      ---
      foo: bar: gee
    YAML
    output = shell_output("#{bin}yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath"good.yaml").write <<~YAML
      ---
      foo: bar
    YAML
    assert_empty shell_output("#{bin}yamllint -f parsable -s good.yaml")
  end
end