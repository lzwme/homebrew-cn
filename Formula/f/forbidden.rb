class Forbidden < Formula
  include Language::Python::Virtualenv

  desc "Bypass 4xx HTTP response status codes and more"
  homepage "https:github.comivan-sincekforbidden"
  url "https:files.pythonhosted.orgpackagesa311c27ee390aca12b1db6cc9f394a525a8e3609de31818a660dbc87a2ca9897forbidden-12.3.tar.gz"
  sha256 "9095063d1c3a43ea3e47b736a548459dc6d21c8bd57e376c800e0c571c8a5258"
  license "MIT"
  head "https:github.comivan-sincekforbidden.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "edf8d5c872fa5aae22c94b763c38471738faed06538b3ebb41f17661ee1859e6"
    sha256 cellar: :any,                 arm64_ventura:  "d3b794ccfc0d00ffcf884806b3a1275568f1fadff443d4511348d065008e9c3d"
    sha256 cellar: :any,                 arm64_monterey: "8fe70dc3dc14dab8fa13367be50580968a5850269c439544ba7f4d2d44d67032"
    sha256 cellar: :any,                 sonoma:         "a0783ab2c4a19824b69a5826e7296ee425f5b587ab30436b57f802b5f8fb7a87"
    sha256 cellar: :any,                 ventura:        "41380d696f36691c6130ceaa25d7e2193928da340912248674d618cd4a313304"
    sha256 cellar: :any,                 monterey:       "07270e96e7800dc209cf3f64de635f8fcf1ffd1657ee6f3fb480b857e53db9b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75f657cc8eadfce869dc5dd84572261e7b06a430cb26c19e6a0472a13e0fd429"
  end

  depends_on "certifi"
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.12"

  resource "about-time" do
    url "https:files.pythonhosted.orgpackages1c3fccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0aabout-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "alive-progress" do
    url "https:files.pythonhosted.orgpackages6acfde25c4f6123c3b3eb5acc87144d3e017df25b32c16806b14572a259939acalive-progress-3.1.5.tar.gz"
    sha256 "42e399a66c8150dc507602dff7b7953f105ef11faf97ddaa6d27b1cbf45c4c98"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "datetime" do
    url "https:files.pythonhosted.orgpackages2f66e284b9978fede35185e5d18fb3ae855b8f573d8c90a56de5f6d03e8ef99eDateTime-5.5.tar.gz"
    sha256 "21ec6331f87a7fcb57bd7c59e8a68bfffe6fcbf5acdbbc7b356d6a9a020191d3"
  end

  resource "grapheme" do
    url "https:files.pythonhosted.orgpackagescee7bbaab0d2a33e07c8278910c1d0d8d4f3781293dfbc70b5c38197159046bfgrapheme-0.6.0.tar.gz"
    sha256 "44c2b9f21bbe77cfb05835fec230bd435954275267fea1858013b102f8603cca"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "pycurl" do
    url "https:files.pythonhosted.orgpackagesc95ae68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagesfb68ce067f09fca4abeca8771fe667d89cc347d1e99da3e093112ac329c6020epyjwt-2.9.0.tar.gz"
    sha256 "7e1e5b56cc735432a7369cbfa0efe50fa113ebecdc04ae6922deba8b84582d0c"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages3a313c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3fpytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesf938148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages3e2cf0a538a2f91ce633a78daaeb34cbfb93a54bd2132a6de1f6cec028eee6efsetuptools-74.1.2.tar.gz"
    sha256 "95b40ed940a1c67eb70fc099094bd6e99c6ee7c23aa2306f4d2697ba7916f9c6"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackages1056d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "zope-interface" do
    url "https:files.pythonhosted.orgpackagesc8837de03efae7fc9a4ec64301d86e29a324f32fe395022e3a5b1a79e376668ezope.interface-7.0.3.tar.gz"
    sha256 "cd2690d4b08ec9eaf47a85914fe513062b20da78d10d6d789a792c0b20307fb1"
  end

  def install
    virtualenv_install_with_resources start_with: "setuptools"
  end

  test do
    output = shell_output(bin"forbidden -u https:brew.sh -t methods -f GET")
    assert_match "\"code\": 200", output
  end
end