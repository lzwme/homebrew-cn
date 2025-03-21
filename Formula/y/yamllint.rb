class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https:github.comadrienvergeyamllint"
  url "https:files.pythonhosted.orgpackages03b8e63eaaee35fb1c0c318addc0855ae7a08aa267dca3fe13c369df84d9e467yamllint-1.36.2.tar.gz"
  sha256 "c9ccc818659736e7b13f7e2f9c3c9bb9ac77445be13e789e7d843e92cb8428ef"
  license "GPL-3.0-or-later"
  head "https:github.comadrienvergeyamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "73141e0ebd56f6abe21bdf119dd66b68ff408817e5e9023069d3b569bb90c1a7"
    sha256 cellar: :any,                 arm64_sonoma:  "507d3e73a7d0090768eeff549092af1aea442bff60bd64483ff9d0f036f13c15"
    sha256 cellar: :any,                 arm64_ventura: "7c6432ecbe2d02c8fc00e1fe04d999238bf49c8308cf908ead6dbc2cc4cb40e3"
    sha256 cellar: :any,                 sonoma:        "77654786b69c881f40bb9816fc88b51a2edba8f9ded99f3e33f924d832c7a1bc"
    sha256 cellar: :any,                 ventura:       "4764f5b53ef49c4b556bff4bae73f1177ee89b7aced6d0214149fc6ebbeed0b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94ec616c71aaf31eafe44c93bcbb5986c0f62e81cda0df05b4cca3fcb7316909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda95cea6ab415ed02e5b05bed4ba76f08c800b63a2ce4a85b5ec42c1f1098e9"
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