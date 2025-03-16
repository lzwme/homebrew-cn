class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https:github.comadrienvergeyamllint"
  url "https:files.pythonhosted.orgpackagesd81ef08445d56c0d32551c9c7e8324888446ccc49ac021ca3b136ab384cef35ayamllint-1.36.1.tar.gz"
  sha256 "a287689daaafc301a80549b2d0170452ebfdcabd826e3fe3b4c66e322d4851fa"
  license "GPL-3.0-or-later"
  head "https:github.comadrienvergeyamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b43cc15cd0027083c23fd5490ce871a385a0e1e8f43d866296aef78328d01be"
    sha256 cellar: :any,                 arm64_sonoma:  "22a169489ae0eabd60073302e086997f712f0c30864c230a4e986a6836d47057"
    sha256 cellar: :any,                 arm64_ventura: "6c8cf751400bffa7f96b5e2fc3b2bbed42cc6e0e10143675701edf75dca54291"
    sha256 cellar: :any,                 sonoma:        "44527f65bd7a554f4148f3c11450bf875549a0368c93c494679ecd2e2ddc7722"
    sha256 cellar: :any,                 ventura:       "d3d440cfb3f2363e755a6918e40491409ad17a62dd3449397d7825ed3e9dd4d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5faad7918e8de86646be149e4733803746c09ff7b9df35ffe4d4ffc8773e3d"
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