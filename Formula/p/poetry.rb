class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https://python-poetry.org/"
  url "https://files.pythonhosted.org/packages/c5/ff/d37625b6d2fe7f3b5a784da4684b011cc56b599f4d9aa249dac7e96b271a/poetry-1.7.0.tar.gz"
  sha256 "796e2866f35cb57af36280a890f5a5b3f9ef1a2dcf780b945b02be2e82895391"
  license "MIT"
  head "https://github.com/python-poetry/poetry.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "429535934ddb3d7dabcbbc1bf794036678e7aa5549f5c50da74582010d1aa630"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9d59671d5352e6219f1fc8aaf9a3dfd803d730432b805a3320c373d93199fd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7822e9ba2585f669800274f0fdd58493dce6b4ce1bdc8f5a7941246d60496b73"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4d29b4223f542fd31e5d81d6a90edf2758502b96abc6f221aeecae6ab38c211"
    sha256 cellar: :any_skip_relocation, ventura:        "8405667c87135dd1732b9f23d5134cb1b7f5412233ad242f76c48fa00c84a80c"
    sha256 cellar: :any_skip_relocation, monterey:       "a4a1ef3b9813041503ac68f8857310a970666dab62bb280ebfa2361759d4f219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfc56c6c5afc71b52a384f2092b949cd65c797129250a7a3d49ff32265beb515"
  end

  depends_on "cmake" => :build # for rapidfuzz
  depends_on "cffi"
  depends_on "keyring"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "virtualenv"

  resource "build" do
    url "https://files.pythonhosted.org/packages/98/e3/83a89a9d338317f05a68c86a2bbc9af61235bc55a0c6a749d37598fb2af1/build-1.0.3.tar.gz"
    sha256 "538aab1b64f9828977f84bc63ae570b060a8ed1be419e7870b8b4fc5e6ea553b"
  end

  resource "cachecontrol" do
    url "https://files.pythonhosted.org/packages/9e/65/3356cfc87bdee0cdf62d941235e936a26c205e4f1e1f2c85dbd952d7533a/cachecontrol-0.13.1.tar.gz"
    sha256 "f012366b79d2243a6118309ce73151bf52a38d4a5dac8ea57f09bd29087e506b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cleo" do
    url "https://files.pythonhosted.org/packages/3c/30/f7960ed7041b158301c46774f87620352d50a9028d111b4211187af13783/cleo-2.1.0.tar.gz"
    sha256 "0b2c880b5d13660a7ea651001fb4acb527696c01f15c9ee650f377aa543fd523"
  end

  resource "crashtest" do
    url "https://files.pythonhosted.org/packages/6e/5d/d79f51058e75948d6c9e7a3d679080a47be61c84d3cc8f71ee31255eb22b/crashtest-0.4.1.tar.gz"
    sha256 "80d7b1f316ebfbd429f648076d6275c877ba30ba48979de4191714a75266f0ce"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/57/e0/1b5f95c2651284a5d4fdfb2cc5ecad57fb694084cce59d9d4acb7ac30ecf/dulwich-0.21.6.tar.gz"
    sha256 "30fbe87e8b51f3813c131e2841c86d007434d160bd16db586b40d47f31dd05b0"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/82/d1/0e54b17b6ebae7a347602bb07bb2f5c4cff9bdbbd354f202b3af48f22f75/fastjsonschema-2.18.1.tar.gz"
    sha256 "06dc8680d937628e993fa0cd278f196d20449a1adc087640710846b324d422ea"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/05/18/ceeb4e3ab3aa54495775775b38ae42b10a92f42ce42dfa44da684289b8c8/installer-0.7.0.tar.gz"
    sha256 "a26d3e3116289bb08216e0d0f7d925fcef0b0194eedfa0c944bcaaa106c4b631"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/b4/1c/89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129/pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/36/66/6af2891495d12020419c8447d0b29c1e96f3be16631faaed6bda5b886d5d/poetry_core-1.8.1.tar.gz"
    sha256 "67a76c671da2a70e55047cddda83566035b701f7e463b32a2abfeac6e2a16376"
  end

  resource "poetry-plugin-export" do
    url "https://files.pythonhosted.org/packages/c4/36/0beed6661369e86447f3550d1d5df529591e046583079dffac10dc86ed21/poetry_plugin_export-1.6.0.tar.gz"
    sha256 "091939434984267a91abf2f916a26b00cff4eee8da63ec2a24ba4b17cf969a59"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/25/c1/374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64c/pyproject_hooks-1.0.0.tar.gz"
    sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/8b/f3/bf5e82eca3b88853a5fe596bf8c94fb6f2775dc1b55b7bfee9de21afab03/rapidfuzz-3.5.2.tar.gz"
    sha256 "9e9b395743e12c36a3167a3a9fd1b4e11d92fb0aa21ec98017ee6df639ed385e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/9b/93/93f12cdd3b9da81e94f2435d01fe6b3e9edc7704a25d4ad260ce7906ca62/tomlkit-0.12.2.tar.gz"
    sha256 "df32fab589a81f0d7dc525a4267b6d7a64ee99619cbd1eeb0fae32c1dd426977"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/5b/fa/49b6a09e4f389d4d9406d2947a685de1462ffb676ea6e61c50905e27b0f4/trove-classifiers-2023.10.18.tar.gz"
    sha256 "2cdfcc7f31f7ffdd57666a9957296089ac72daad4d11ab5005060e5cd7e29939"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "xattr" do
    url "https://files.pythonhosted.org/packages/a0/19/dfb42dd6e6749c6e6dde55b12ee44b3c8247c3cfa5b85180a60902722538/xattr-0.10.1.tar.gz"
    sha256 "c12e7d81ffaa0605b3ac8c22c2994a8e18a9cf1c59287a1b7722a2289c952ec5"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[keyring virtualenv].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    generate_completions_from_executable(bin/"poetry", "completions")
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

    # The poetry add command would fail in CI when keyring is enabled
    # https://github.com/Homebrew/homebrew-core/pull/109777#issuecomment-1248353918
    ENV["PYTHON_KEYRING_BACKEND"] = "keyring.backends.null.Keyring"

    assert_match version.to_s, shell_output("#{bin}/poetry --version")
    assert_match "Created package", shell_output("#{bin}/poetry new homebrew")

    cd testpath/"homebrew" do
      system bin/"poetry", "config", "virtualenvs.in-project", "true"
      system bin/"poetry", "add", "requests"
      system bin/"poetry", "add", "boto3"
    end

    assert_predicate testpath/"homebrew/pyproject.toml", :exist?
    assert_predicate testpath/"homebrew/poetry.lock", :exist?
    assert_match "requests", (testpath/"homebrew/pyproject.toml").read
    assert_match "boto3", (testpath/"homebrew/pyproject.toml").read
  end
end