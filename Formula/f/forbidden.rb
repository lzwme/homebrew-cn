class Forbidden < Formula
  include Language::Python::Virtualenv

  desc "Bypass 4xx HTTP response status codes and more"
  homepage "https:github.comivan-sincekforbidden"
  url "https:files.pythonhosted.orgpackagesa3bd07a1b00ed63815153713a6b7fa814174b798ab0c1fa97d6e6b6d0d50ccabforbidden-12.6.tar.gz"
  sha256 "c4bee241622d64b813295f9f58681fb05cc3fd547264ef6bd6495c2fca74f605"
  license "MIT"
  head "https:github.comivan-sincekforbidden.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d227f941f15946cd8b17df192e0c4ff78d534ba2fd315eadadef0a90e28a575a"
    sha256 cellar: :any,                 arm64_sonoma:  "c4ce0f326e40e9b1c7d2be722b9eb815248d327337d09a04b934bdc27ba58a4a"
    sha256 cellar: :any,                 arm64_ventura: "c66728a3bb8ab7b65b41279fdaf792b5ba35a55c068bddf8160382ac437d9ae2"
    sha256 cellar: :any,                 sonoma:        "d560dfbda1b10af0d10c38a2ee191fa7504ea8fecb10806942b339c6f05b681a"
    sha256 cellar: :any,                 ventura:       "162af7d62a03c2d9660d7ba6f1cac1e1b437fe7bab5b0f974da49b7895345fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6d95f560e280536ad46ecb41891736f4aff42943ca470db93f494b6049e729f"
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

  resource "grapheme" do
    url "https:files.pythonhosted.orgpackagescee7bbaab0d2a33e07c8278910c1d0d8d4f3781293dfbc70b5c38197159046bfgrapheme-0.6.0.tar.gz"
    sha256 "44c2b9f21bbe77cfb05835fec230bd435954275267fea1858013b102f8603cca"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pycurl" do
    url "https:files.pythonhosted.orgpackagesc95ae68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"

    # Remove -flat_namespace
    # PR ref: https:github.compycurlpycurlpull855
    on_sequoia :or_newer do
      patch do
        url "https:github.compycurlpycurlcommit7deb85e24981e23258ea411dcc79ca9b527a297d.patch?full_index=1"
        sha256 "a49fa9143287398856274f019a04cf07b0c345560e1320526415e9280ce2efbc"
      end
    end
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagesfb68ce067f09fca4abeca8771fe667d89cc347d1e99da3e093112ac329c6020epyjwt-2.9.0.tar.gz"
    sha256 "7e1e5b56cc735432a7369cbfa0efe50fa113ebecdc04ae6922deba8b84582d0c"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackagesf938148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}forbidden -u https:brew.sh -t methods -f GET")
    assert_match '"code": 200', output
  end
end