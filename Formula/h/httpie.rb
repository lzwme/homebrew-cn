class Httpie < Formula
  include Language::Python::Virtualenv

  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https:httpie.io"
  url "https:github.comhttpiecliarchiverefstags3.2.4.tar.gz"
  sha256 "b185cd8d81325f97c773582e50f1c5e047c2d8575b53d676469c9daf2a52f341"
  license "BSD-3-Clause"
  revision 3
  head "https:github.comhttpiecli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad6f4550d781c22d796e23ba8e92fb03b34906da05fd527a7f9fb57930157458"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda7c60d40adb6aa1c0b29fcc13c874327e2d8856ddd8740e00894da3dc46077"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7801dbbc9b305f9cc1d1fe31c5fe0bc912a5287f3cc142e0b303b71797f9446b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a1f7841e53bd6341fdf80acc2c329b4cadef07889b2afcdf90c7466de568b2e"
    sha256 cellar: :any_skip_relocation, ventura:       "06f5697bb8d7e656083a84b3982dc0d6d6e56dd47b80011c3a142d66b433d70f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40791df8fe2938242a5c75c65cce7ddfca12b1f95d3e06ed85fd1bfc2bd236e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4746efa50922ae0839f4aceb892ba60dabfa6ff706bb83f9d6592c4ff42593"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
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
    url "https:files.pythonhosted.orgpackages46b559f27b4ce9951a4bce56b88ba5ff5159486797ab18863f2b4c1c5e8465bdmultidict-6.5.0.tar.gz"
    sha256 "942bd8002492ba819426a8d7aefde3189c1b87099cdf18aaaefefcf7f3f7b6d2"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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