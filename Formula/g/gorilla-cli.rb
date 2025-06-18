class GorillaCli < Formula
  include Language::Python::Virtualenv

  desc "LLMs for your CLI"
  homepage "https:gorilla.cs.berkeley.edu"
  url "https:files.pythonhosted.orgpackagescd2b7a64f9ad59009e72ddf73d055195b4bf23e15599a61e66f1458b4025b9e5gorilla-cli-0.0.10.tar.gz"
  sha256 "bf375230a06fac99ba56f14f49474466036f072751cd1d5a1908e8ace561856c"
  license "Apache-2.0"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ba6432daac48104b89bfd8d0ebc549e05f9b010f4e2c9be42349ba7959560af6"
  end

  # service is down: https:github.comgorilla-llmgorilla-cliissues64
  deprecate! date: "2025-06-17", because: :unmaintained

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "halo" do
    url "https:files.pythonhosted.orgpackagesee48d53580d30b1fabf25d0d1fcc3f5b26d08d2ac75a1890ff6d262f9f027436halo-0.0.31.tar.gz"
    sha256 "7b67a3521ee91d53b7152d4ee3452811e1d2a6321975137762eb3d70063cc9d6"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "log-symbols" do
    url "https:files.pythonhosted.orgpackages4587e86645d758a4401c8c81914b6a88470634d1785c9ad09823fa4a1bd89250log_symbols-0.0.14.tar.gz"
    sha256 "cf0bbc6fe1a8e53f0d174a716bc625c4f87043cc21eb55dd8a740cfe22680556"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesbb6e9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1cprompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "spinners" do
    url "https:files.pythonhosted.orgpackagesd391bb331f0a43e04d950a710f402a0986a54147a35818df0e1658551c8d12e1spinners-0.0.24.tar.gz"
    sha256 "1eb6aeb4781d72ab42ed8a01dcf20f3002bf50740d7154d12fb8c9769bf9e27f"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackagesca6c3d75c196ac07ac8749600b60b03f4f6094d54e132c4d94ebac6ee0e0add0termcolor-3.1.0.tar.gz"
    sha256 "6a6dd7fbee581909eeec6a756cff1d7f7c376063b14e4a298dc4980309e55970"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "config", "--global", "user.email", "BrewTestBot@example.com"
    (testpath".gorilla-cli-userid").write "BrewTestBot"
    # FIXME: Upstream's API https:cli.gorilla-llm.com has expired SSL cert.
    # Temporarily allow our test to pass until upstream has time to fixrespond.
    # https:github.comgorilla-llmgorilla-cliissues64
    Open3.popen3("#{bin}gorilla", "do", "nothing") do |stdin, stdout|
      assert_match((Welcome to Gorilla|Server is unreachable), stdout.readline)
      stdin.write("\n")
    end
  end
end