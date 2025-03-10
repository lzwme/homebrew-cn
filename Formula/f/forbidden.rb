class Forbidden < Formula
  include Language::Python::Virtualenv

  desc "Bypass 4xx HTTP response status codes and more"
  homepage "https:github.comivan-sincekforbidden"
  url "https:files.pythonhosted.orgpackages281471974166379e5e57750a6855932f7326b37091733fb42d5259918b9df97eforbidden-13.0.tar.gz"
  sha256 "b61e7cf6ce9cce031eba22b1c562bb3c11ce34d1e44230b7f8e0ef3996f60d34"
  license "MIT"
  head "https:github.comivan-sincekforbidden.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d6543f959f8249d1f5fda731f4c77809c60ba2f7bb1b2fdeb4a074bbaba3e7c7"
    sha256 cellar: :any,                 arm64_sonoma:  "84c84210c7f87864f200af806a867453ce1c62497920f4ea075f112ee0408156"
    sha256 cellar: :any,                 arm64_ventura: "7f9156c0e8415ee35cd7182788567797077e8bde5ddfd287607c09f9b992e4ab"
    sha256 cellar: :any,                 sonoma:        "25f2376cac3fdcca7419102f9f17b1ec010c114fc33159d7a1ab6316087092d3"
    sha256 cellar: :any,                 ventura:       "27af14a3880f890208202e49bab4b64e12c2463e4ba144caf46a19b90fe41455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50d6a8151053fd830385b2d09f1e0669333053c52779ad718536ffbea582b522"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "about-time" do
    url "https:files.pythonhosted.orgpackages1c3fccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0aabout-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "alive-progress" do
    url "https:files.pythonhosted.orgpackages2866c2c1e6674b3b7202ce529cf7d9971c93031e843b8e0c86a85f693e6185b8alive-progress-3.2.0.tar.gz"
    sha256 "ede29d046ff454fe56b941f686f89dd9389430c4a5b7658e445cb0b80e0e4deb"
  end

  resource "bot-safe-agents" do
    url "https:files.pythonhosted.orgpackages6a06a557cece31bdf2992db8099f3e0e3296e955cf681f0cab4a5dc89779c984bot_safe_agents-1.0.tar.gz"
    sha256 "8b2d9e435ec10a89563b10a6ca977bbf8fb43cf4eca7d8e412e2e69c8aff400c"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
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
    url "https:files.pythonhosted.orgpackages7135fe5088d914905391ef2995102cf5e1892cf32cab1fa6ef8130631c89ec01pycurl-7.45.6.tar.gz"
    sha256 "2b73e66b22719ea48ac08a93fc88e57ef36d46d03cb09d972063c9aa86bb74e6"
  end

  resource "pyjwt" do
    url "https:files.pythonhosted.orgpackagese746bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
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
    url "https:files.pythonhosted.orgpackages377288311445fd44c455c7d553e61f95412cf89054308a1aa2434ab835075fc5termcolor-2.5.0.tar.gz"
    sha256 "998d8d27da6d48442e8e1f016119076b690d962507531df4890fcd2db2ef8a6f"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}forbidden -u https:brew.sh -t methods -f GET")
    assert_match "\"status\": 200", output
  end
end