class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package and dependency manager supporting the latest PEP standards"
  homepage "https:pdm.fming.dev"
  url "https:files.pythonhosted.orgpackages7c6e833eb584b0189c5a2399e9dae1310a9c26ef09ff3185f33012f3493b4d9apdm-2.12.1.tar.gz"
  sha256 "39a2aba19986c945a79bf584c3775285e24e9c7f8ed8a603815b61c5fac5db4c"
  license "MIT"
  head "https:github.compdm-projectpdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1184a023a67fa5257aeb60ac2ed8c0c95ea017ee1922d5b1ec8bf5773c33901"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e76c6bad3bc35eeea1c353842416e3282625405dae65b2c9ef82843afd6ff575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53b010ed50c2441ad3c3d74c06ece58c9a57ee40a166b4a920d30a3ee5b8e417"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f1a8ff944e22f86400940069b394e5605e265d4b7dcc4fe39bbe9292178eb94"
    sha256 cellar: :any_skip_relocation, ventura:        "c059d637dd66f1bb0711baa880c88fe5fdd0f7e9a3edb8cb0c8e7a0c2d141b01"
    sha256 cellar: :any_skip_relocation, monterey:       "6f2d035379d156274d6e0617c4afb15ac83088dd9cd78b850832ff9402bc0da0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c938b5c9146276ae8cc6ac8916465abf23fc03b10afa0af7a6508fb70915df8b"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-pyproject-hooks"
  depends_on "python@3.12"
  depends_on "virtualenv"

  resource "blinker" do
    url "https:files.pythonhosted.orgpackagesa1136df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9eblinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
  end

  resource "cachecontrol" do
    url "https:files.pythonhosted.orgpackages9e653356cfc87bdee0cdf62d941235e936a26c205e4f1e1f2c85dbd952d7533acachecontrol-0.13.1.tar.gz"
    sha256 "f012366b79d2243a6118309ce73151bf52a38d4a5dac8ea57f09bd29087e506b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dep-logic" do
    url "https:files.pythonhosted.orgpackagesfe6baab4ea5d80af862612f4efdf7ccc3a1dc2b24bf499e5658b45ba89a7c127dep_logic-0.0.4.tar.gz"
    sha256 "1830e784e0d58fc93511e77da164887629641b65b38876b274db974ec5f3889f"
  end

  resource "findpython" do
    url "https:files.pythonhosted.orgpackages89e4acf061c1b86fbe7c4cc3863002ffcb273d3d7ecd9c5dedd65aa9ec8a8139findpython-0.4.1.tar.gz"
    sha256 "d7d014558681b3761d57a5b2342a713a8bf302f6c1fc9d99f81b9d8bd1681b04"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "installer" do
    url "https:files.pythonhosted.orgpackages0518ceeb4e3ab3aa54495775775b38ae42b10a92f42ce42dfa44da684289b8c8installer-0.7.0.tar.gz"
    sha256 "a26d3e3116289bb08216e0d0f7d925fcef0b0194eedfa0c944bcaaa106c4b631"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagesc2d55662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackages31061ef763af20d0572c032fa22882cfbfb005fba6e7300715a37840858c919epython-dotenv-1.0.0.tar.gz"
    sha256 "a8df96034aae6d2d50a4ebe8216326c61c3eb64836776504fcca410e5937a3ba"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "resolvelib" do
    url "https:files.pythonhosted.orgpackagesce10f699366ce577423cbc3df3280063099054c23df70856465080798c6ebad6resolvelib-1.0.1.tar.gz"
    sha256 "04ce76cbd63fded2078ce224785da6ecd42b9564b1390793f64ddecbe997b309"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesdffc1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
  end

  resource "truststore" do
    url "https:files.pythonhosted.orgpackages25fa852059855159181dba77129770834e419e0235ecf99a2c0e0d15a2b18a31truststore-0.8.0.tar.gz"
    sha256 "dc70da89634944a579bfeec70a7a4523c53ffdb3cf52d1bb4a431fda278ddb96"
  end

  resource "unearth" do
    url "https:files.pythonhosted.orgpackages2c8e55f2075b91268108c97e025275dd6cf0c03ec648ba28834f9c79fbc64fe1unearth-0.14.0.tar.gz"
    sha256 "f3cddfb94ac0f865fbcf964231556ef7183010379c00b01205517a50c78a186d"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb0b4bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97bwheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[virtualenv].map { |p| Formula[p].opt_libexecsite_packages }
    (libexecsite_packages"homebrew-deps.pth").write paths.join("\n")

    generate_completions_from_executable(bin"pdm", "completion")
  end

  test do
    (testpath"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

      [build-system]
      requires = ["pdm-backend"]
      build-backend = "pdm.backend"
    EOS
    system bin"pdm", "add", "requests==2.31.0"
    assert_match "dependencies = [\n    \"requests==2.31.0\",\n]", (testpath"pyproject.toml").read
    assert_predicate testpath"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath"pdm.lock").read
    output = shell_output("#{bin}pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.31.0", output.strip
  end
end