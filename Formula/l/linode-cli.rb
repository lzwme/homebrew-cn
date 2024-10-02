class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https:github.comlinodelinode-cli"
  url "https:files.pythonhosted.orgpackages16c6e06d574c8a7124b0d0b247fa6d3ff680af2f37fadafc3fc42fb49e503cedlinode_cli-5.52.0.tar.gz"
  sha256 "3d45caa2f269ae2ba673167c443040f902a3da990a53afa2e4beec2901d59aea"
  license "BSD-3-Clause"
  head "https:github.comlinodelinode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "35f85f6895059976e51eaf2b414b5e9b9e2909477947c79d6d6dee5c45f5ab3c"
    sha256 cellar: :any,                 arm64_sonoma:  "9209687c1b21f839dc2ea52e7d1292a7ac5259e6f52049276ff5e90c9abbb5ce"
    sha256 cellar: :any,                 arm64_ventura: "1b60cc161c8eea3365b6523b815550b6eed55ccbae1eae70c50122cecf8e68e3"
    sha256 cellar: :any,                 sonoma:        "ee690f4264336d3cf04888e8077a93f798a85328f5de02fa8685feaff57b09ac"
    sha256 cellar: :any,                 ventura:       "c43720b9be3bac13c11297b9582e2b4dc98af56f447eb1880d21c695dfdd3951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5937c00496ebd9cb1975781535e554e71a9cd4fed3f2b88c3eca9ba68d5eecda"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages7849f3f17ec11c4a91fe79275c426658e509b07547f874b14c1a526d86a83fc8anyio-4.6.0.tar.gz"
    sha256 "137b4559cbb034c477165047febb6ff83f390fc3b20bf181c1fc0a728cb8beeb"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackagesb644ed0fa6a17845fb033bd885c03e842f08c1b9406c86a2e60ac1ae1b9206a6httpcore-1.0.6.tar.gz"
    sha256 "73f6dbd6eb8c21bbf7ef8efad555481853f5f6acdeaff1edb0694289269ee17f"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages788208f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "linode-metadata" do
    url "https:files.pythonhosted.orgpackages37d0648f568aac2d016bc3c8c7e88934181d679d84c49dcd808b2398f0eddb5flinode_metadata-0.3.0.tar.gz"
    sha256 "6450aff5fe216e205a26e2afcecfc1185a0ffa6005c156bc385176d9bdb6be82"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "openapi3" do
    url "https:files.pythonhosted.orgpackages940ae7862c7870926ecb86d887923e36b7853480a2a97430162df1b972bd9d5bopenapi3-1.8.2.tar.gz"
    sha256 "a21a490573d89ca69ada7cbe585adb2fca4964257f6f3a1df531f12815455d2c"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb37887d00a1df7c457ad9aa0139f01b8a11c67209f27f927c503b0109bf2ed6crich-13.9.1.tar.gz"
    sha256 "097cffdf85db1babe30cc7deba5ab3a29e1b9885047dab24c57e9a7f8a9c1466"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin"linode-cli", "completion", shells: [:bash, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}linode-cli --version")

    require "securerandom"
    random_token = SecureRandom.hex(32)
    with_env(
      LINODE_CLI_TOKEN: random_token,
    ) do
      json_text = shell_output("#{bin}linode-cli regions view --json us-east")
      region = JSON.parse(json_text)[0]
      assert_equal region["id"], "us-east"
      assert_equal region["country"], "us"
    end
  end
end