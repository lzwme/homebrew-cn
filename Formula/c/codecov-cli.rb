class CodecovCli < Formula
  include Language::Python::Virtualenv

  desc "Codecov's command-line interface"
  homepage "https:cli.codecov.io"
  url "https:files.pythonhosted.orgpackages2da406b2261074ff110f8028a58f75ea196974305eff475a3cb4c99f3c616601codecov-cli-0.7.3.tar.gz"
  sha256 "126261cb308c70899a5b667517a9eccce8980e3c036627920f6fe613109ac013"
  license "Apache-2.0"
  head "https:github.comcodecovcodecov-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b287c2959805a3ef26d0e63559614d37c438ac786777866033c7646c1d5b3c88"
    sha256 cellar: :any,                 arm64_ventura:  "640905c87f0898622867cb7d013f27bb8d3d1c43fb82ef7faa0deb1b6f9b1c52"
    sha256 cellar: :any,                 arm64_monterey: "9b678dac61d0ed369de7be03658c35b93492266560e4d6bd64408c5c6450e08f"
    sha256 cellar: :any,                 sonoma:         "098bca56b833360f3e04927279b648cf11f93f011ec3a4543762780c88a893b2"
    sha256 cellar: :any,                 ventura:        "14258a3f27fa523e0f8cd8ba448e25ad9b4f6a41cc4ed16790dbe5c8e6b8f5c8"
    sha256 cellar: :any,                 monterey:       "dda6d385b7d21fd9687c8f1f9e6371e1986958bd2494e7b400b85d525810e74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efd78b377f5a98d1fdee60770d8155a838f1b4c8f9b18af304be4f83475b3fbc"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagese6e3c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackagesc202a95f2b11e207f68bc64d7aae9666fed2e2b3f307748d5123dffb72a1bbeacertifi-2024.7.4.tar.gz"
    sha256 "5a1e7645bc0ec61a09e26c36f6106dd4cf40c6db3a1fb6352b0244e7fb057c7b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages61425c456b02816845d163fab0f32936b6a5b649f3f915beff6f819f4f6c90b2httpcore-0.16.3.tar.gz"
    sha256 "c5d6f04e2fc530f39e0c077e6a30caa53f1451096120f1f38b954afd0b17c0cb"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesf55004d5e8ee398a10c767a341a25f59ff8711ae3adf0143c7f8b45fc560d72dhttpx-0.23.3.tar.gz"
    sha256 "9818458eb565bb54898ccb9b8b251a28785dd4a55afbc23d0eb410754fe7d0f9"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "ijson" do
    url "https:files.pythonhosted.orgpackages6c8328e9e93a3a61913e334e3a2e78ea9924bb9f9b1ac45898977f9d9dd6133fijson-3.3.0.tar.gz"
    sha256 "7f172e6ba1bee0d4c8f8ebd639577bfe429dee0f3f96775a067b8bae4492d8a0"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages7adb5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49bregex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "responses" do
    url "https:files.pythonhosted.orgpackages6ddbb949a6bf2a75c64caea0a6b39d05e433aa2e51bea78ae9d5dda1110b31a5responses-0.21.0.tar.gz"
    sha256 "b82502eb5f09a0289d8e209e7bad71ef3978334f56d09b444253d5ad67bf5253"
  end

  resource "rfc3986" do
    url "https:files.pythonhosted.orgpackages79305b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages32c05b8013b5a812701c72e3b1e2b378edaa6514d06bee6704a5ab0d7fa52931setuptools-71.1.0.tar.gz"
    sha256 "032d42ee9fb536e33087fb66cac5f840eb9391ed05637b3f2a76a7c8fb477936"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "test-results-parser" do
    url "https:files.pythonhosted.orgpackagesfa1f35f5b23beb148c36285bfe9722adeaef976814670ebf9bd8129356a283c8test_results_parser-0.1.0.tar.gz"
    sha256 "0034281a4b406d7f072fc5ac1f5e44660e3c23bc92f2e7284862ee097f9626ee"
  end

  resource "tree-sitter" do
    url "https:files.pythonhosted.orgpackages4a6471b3a0ff7d0d89cb333caeca01992099c165bdd663e7990ea723615e60f4tree_sitter-0.20.4.tar.gz"
    sha256 "6adb123e2f3e56399bbf2359924633c882cc40ee8344885200bca0922f713be5"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "securerandom"

    assert_equal "codecovcli, version #{version}\n", shell_output("#{bin}codecovcli --version")

    # Unfortunately `shell_output` doesn't capture standard error
    output = shell_output(["#{bin}codecovcli create-report --commit-sha #{SecureRandom.hex(40)}",
                           "--slug testrepo --token #{SecureRandom.hex(10)} 2>&1"].join(" "))

    ["No config file could be found. Ignoring config.",
     "Process Report creating complete",
     "Report creating failed: {\"detail\":\"Not valid tokenless upload\"}"].each do |l|
       assert_match l, output
     end
  end
end