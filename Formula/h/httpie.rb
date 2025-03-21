class Httpie < Formula
  include Language::Python::Virtualenv

  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https:httpie.io"
  url "https:github.comhttpiecliarchiverefstags3.2.4.tar.gz"
  sha256 "b185cd8d81325f97c773582e50f1c5e047c2d8575b53d676469c9daf2a52f341"
  license "BSD-3-Clause"
  head "https:github.comhttpiecli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83e92884af29f9d3f550603b35715ad22d04a353d754a0c9f237318166f24147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e6306cd7e9fb707552d406186b25a1774e436e218ec2ca1f8cc44319d73f591"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e92db0acf947533e3ef430e7c0030819d2a616ad0290bbd2ba3038cdd53afcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c2b7f472c1baf574ac82ad47299ad3b838b1cb287d98165a395d5b05e371ad6"
    sha256 cellar: :any_skip_relocation, ventura:       "49df2e4365298b54ebf24b0bd661e06f73dd3844d7575de76c74467c8cda8f3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c574ce8746fe865719cd707022de24ec05a57733eaba7cf075b8bac19548233b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72dc884db737283760aae001baadbf96fc3dd71119545eb09783f1523654408b"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesd6be504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesed22a438e0caa4576f8c383fa4d35f1cc01655a46c75be358960d815bfbb12bdsetuptools-75.3.0.tar.gz"
    sha256 "fba5dd4d766e97be1b1681d98712680ae8f2f26d7881245f2ce9e40714f1a686"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    # We use a special file called __build_channel__.py to denote which source
    # was used to install httpie.
    File.write("httpieinternal__build_channel__.py", "BUILD_CHANNEL = \"homebrew\"")

    virtualenv_install_with_resources

    bash_completion.install "extrashttpie-completion.bash" => "httpie"
    fish_completion.install "extrashttpie-completion.fish" => "httpie.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}httpie --version")
    assert_match version.to_s, shell_output("#{bin}https --version")
    assert_match version.to_s, shell_output("#{bin}http --version")

    raw_url = "https:raw.githubusercontent.comHomebrewhomebrew-coreHEADFormulahhttpie.rb"
    assert_match "PYTHONPATH", shell_output("#{bin}http --ignore-stdin #{raw_url}")
  end
end