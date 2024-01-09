class PipAudit < Formula
  include Language::Python::Virtualenv

  desc "Audits Python environments and dependency trees for known vulnerabilities"
  homepage "https://pypi.org/project/pip-audit/"
  url "https://files.pythonhosted.org/packages/ff/bb/8cb2f6721d2cc2f1213b0522748046be9d40ed767e5169189fed1d08765b/pip_audit-2.6.3.tar.gz"
  sha256 "bd796066f69684b2f4fc2c2b6d222589e23190db0bbde069cea5c2b0be2cc57d"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec80a4c620717fb1ad90941d59df722be212f77204392a38c4bbce1504697a0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ff18c3c1548b6c1a8e817a5e1cefb5ffdb23ba8a8be42155b40064607018b3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4826074ae013c62a93174cb6002da6e3a3f0bcc99b8c84944606c0b1f1b4a36c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1719d972f4b233eb3ba91387d3c74f6a5900aad5403addcc8c8176bbc952a5a1"
    sha256 cellar: :any_skip_relocation, ventura:        "80ba470f3954674cfd65078e21a540bdc714a99a5b1ed51f088573acff18e81b"
    sha256 cellar: :any_skip_relocation, monterey:       "eb462a43504dde2136e081742322dfed00790a907cfcdc9ca8a2dd90cbe5233b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2283bbbe20614e1e22fd07ceb418ddc1fd098ea20ec9bb948816d0315b9f67e1"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python-toml"
  depends_on "python@3.12"
  depends_on "six"

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/a2/d9/b6e56a303d221fc0bdff2c775e4eef7fedd58194aa5a96fa89fb71634cc9/boolean.py-4.0.tar.gz"
    sha256 "17b9a181630e43dde1851d42bef546d616d5d9b4480357514597e78b203d06e4"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/9e/65/3356cfc87bdee0cdf62d941235e936a26c205e4f1e1f2c85dbd952d7533a/cachecontrol-0.13.1.tar.gz"
    sha256 "f012366b79d2243a6118309ce73151bf52a38d4a5dac8ea57f09bd29087e506b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/e7/8c/4a3db7f66dcca7a9fc2086375e45f34bd98a11bd8089a8e264015b1f74e8/cyclonedx_python_lib-6.3.0.tar.gz"
    sha256 "82f2489de3c0cadad5af1ad7fa6b6a185f985746370245d38769699c734533c6"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/8b/5c/db493282aeb3f05e89b4db45898faddaa339740eaccb752942042410703f/license-expression-30.2.0.tar.gz"
    sha256 "599928edd995c43fc335e0af342076144dc71cb858afa1ed9c1c30c4e81794f5"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/b5/64/56122e785f91009ff4df4bdc068b7026b46d627636b4a6312ec6f323fc6d/packageurl-python-0.13.3.tar.gz"
    sha256 "63514d3b72f22a9c092913b3fa7b4670e479998dff3d93597863c413735e2ec7"
  end

  resource "pip-api" do
    url "https://files.pythonhosted.org/packages/69/a2/90dd01b87277ae65a6fb725dae86a039aeb34e24f576600abd0434aa95c4/pip-api-0.0.30.tar.gz"
    sha256 "a05df2c7aa9b7157374bcf4273544201a0c7bae60a9c65bcf84f3959ef3896f3"
  end

  resource "pip-requirements-parser" do
    url "https://files.pythonhosted.org/packages/5e/2a/63b574101850e7f7b306ddbdb02cb294380d37948140eecd468fae392b54/pip-requirements-parser-32.0.1.tar.gz"
    sha256 "b4fa3a7a0be38243123cf9d1f3518da10c51bdb165a2b2985566247f9155a7d3"
  end

  resource "py-serializable" do
    url "https://files.pythonhosted.org/packages/01/74/fdfbb3c4af7c14477099809ad32be0964b8fefac9969c5932bb71dbd07e3/py-serializable-0.17.1.tar.gz"
    sha256 "875bb9c01df77f563dfcd1e75bb4244b5596083d3aad4ccd3fb63e1f5a9d3e5f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"requirements.txt"
    test_file.write <<~EOS
      six==1.16.0
    EOS
    output = shell_output("#{bin}/pip-audit --requirement #{test_file} --no-deps --progress-spinner=off 2>&1")
    assert_match "No known vulnerabilities found", output
  end
end