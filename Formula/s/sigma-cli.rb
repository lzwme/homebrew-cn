class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https:github.comSigmaHQsigma-cli"
  url "https:files.pythonhosted.orgpackagescf45eef555a909ff716108ded653decf0a7642bc80169fff9590b665638164a0sigma_cli-1.0.2.tar.gz"
  sha256 "8cb46dca0c5787969f33152c3cd085989fbc07a121d1c9a795664f7264c7ce9f"
  license "LGPL-2.1-or-later"
  head "https:github.comSigmaHQsigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6b6e701817b106320edb36fec0cf1510f82c8c49e55ec94fffeaeeaf7068480a"
    sha256 cellar: :any,                 arm64_ventura:  "814e141c723946566290a9fa2b4d8af367e3c766c19af2c213566d1877ac8632"
    sha256 cellar: :any,                 arm64_monterey: "7693bea3f840d315573968ca20c7ab5af80a77400b1ec36063ac16efdd07110b"
    sha256 cellar: :any,                 sonoma:         "76edd487f5668b1c65dabd348e5059a7b09ce43af74c1c8eed1665ced2712ce7"
    sha256 cellar: :any,                 ventura:        "f5d26f222f1800fa6079eadadc513fe255fc34e7208f6d98ac49c4d02ec6746a"
    sha256 cellar: :any,                 monterey:       "a10d17679c2253a82e387deb3ecea12f9a69d7afd8d6922c72d18aa13ccd8d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e98fb83cf6151163c436b4e9554f45fa910f066fbff4bd030d70bcbd372072d1"
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
    url "https:files.pythonhosted.orgpackages8e67c02ba2ea1a93c9b614a7f694d62421dd8416da33b9ce8db9c39a55592885pysigma-0.11.5.tar.gz"
    sha256 "de27ef86db1b9341a8b540ca4691f489a9f5d63bc2de40bb3257221404d4f2d1"
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
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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