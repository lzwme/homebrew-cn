class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https:github.comSigmaHQsigma-cli"
  url "https:files.pythonhosted.orgpackagese97e6d086e07a9074ff87ec1ce8253f0bfdf164a4bf897e87a9599aceeb17355sigma_cli-1.0.3.tar.gz"
  sha256 "6274a43b710f1af95b6e769efca7586a7392d0b847ef4ec9fe0064bd867a4c8d"
  license "LGPL-2.1-or-later"
  head "https:github.comSigmaHQsigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4fca683e22341898fa7d014aaa91b47eb1a1b81f1eda1f81cf754e4b64ae228b"
    sha256 cellar: :any,                 arm64_ventura:  "fd7ae5acfa4e7a6186e089b0b29c0680d4d31ada7852f846f76b3202737f0a98"
    sha256 cellar: :any,                 arm64_monterey: "31bc330af5fdaff22c1798df1cf74831e7794e55fd991a5267b60f7811555cdc"
    sha256 cellar: :any,                 sonoma:         "f10638dfd9a0360f6847ded2017ef1b78589433cebf9342d2c1ace7387b11c01"
    sha256 cellar: :any,                 ventura:        "373cda0c60d07f4f64c478ab8de83f4d740de4c64c76c60c7d739600009fea2c"
    sha256 cellar: :any,                 monterey:       "4f662df29297cfbfb18ef3282270c7600bdd5b0c1ac39b81ee2567563223d5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6b91b6a2a984e62bcf9785597fac96a4ec273763d4f936e0f7b8cba5b2706e8"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackages19d37cb826e085a254888d8afb4ae3f8d43859b13149ac8450b221120d4964c9prettytable-3.10.0.tar.gz"
    sha256 "9665594d137fb08a1117518c25551e0ede1687197cf353a4fdc78d27e1073568"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages463a31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "pysigma" do
    url "https:files.pythonhosted.orgpackagesdd6b964e015e1ef78647696eddf6ca58807f1c3ef409f26d9c0601db7b3b86dcpysigma-0.11.7.tar.gz"
    sha256 "0414db911bdb8aea11967e64a53da4288b869374135ee81a0e5e3658c7a79eb6"
  end

  resource "pysigma-backend-sqlite" do
    url "https:files.pythonhosted.orgpackagesf9a744f3af755fc30d693c9c1242b8f3e52507ffaed34c4847329c3eb0ba62f3pysigma_backend_sqlite-0.1.2.tar.gz"
    sha256 "9a57a4f89689f980c4cd53cdfb2f8fbfc49ea301b9446f39659e9a84f688302f"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sigma version")

    output = shell_output("#{bin}sigma plugin list")
    assert_match "SQLite and Zircolite backend", output

    # Only show compatible plugins
    output = shell_output("#{bin}sigma plugin list --compatible")
    refute_match "Datadog Cloud SIEM backend", output
  end
end