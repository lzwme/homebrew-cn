class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https://github.com/magic-wormhole/magic-wormhole"
  url "https://files.pythonhosted.org/packages/cc/e1/75c31ad5db873268ba0750006b3d0e40c30b0ad39e6f58b1e28a28d6de48/magic-wormhole-0.13.0.tar.gz"
  sha256 "ac3bd68286270e7f149c06149a8e409e5fa34d7feb0e88844a26d29eed2d1516"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c11c68a6c13f5a69b0ade5592d2332185bc874db1cfb4d4452ebeb94fbf7a0e"
    sha256 cellar: :any,                 arm64_ventura:  "060e9ca5eab90501103fe06f4ca7e90f18b84aa327fc3544ad4f184c39eb2447"
    sha256 cellar: :any,                 arm64_monterey: "39f36fb6c40a9f623c58c7fdc7509127d48facf447d3065180990e60efbcb87a"
    sha256 cellar: :any,                 sonoma:         "f9b2dab69195f87b3f95df968a163c964d9b7ad780bafef716ef0bd768ec37af"
    sha256 cellar: :any,                 ventura:        "d9e6f9cd2eb32cc35a573a1677bb619920ba43804b2a0dee87a11a53c0283c6e"
    sha256 cellar: :any,                 monterey:       "2584db38b3e6058181d7841cf26d20fce45067066286975a8012dfe124159400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3981b8cd256b51960bf250662089e61878451f9e1aad120ed1784d31881ef28e"
  end

  depends_on "cffi"
  depends_on "libsodium"
  depends_on "python-cryptography"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "autobahn" do
    url "https://files.pythonhosted.org/packages/92/ee/c3320c326919394ff597592549ff5d29d2f7bf12be9ddaa9017caff1a170/autobahn-23.6.2.tar.gz"
    sha256 "ec9421c52a2103364d1ef0468036e6019ee84f71721e86b36fe19ad6966c1181"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/7a/7b/9c3d26d8a0416eefbc0428f168241b32657ca260fb7ef507596ff5c2f6c4/Automat-22.10.0.tar.gz"
    sha256 "e56beb84edad19dcc11d30e8d9b895f75deeb5ef5e96b84a467066b3b84bb04e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "hkdf" do
    url "https://files.pythonhosted.org/packages/c3/be/327e072850db181ce56afd51e26ec7aa5659b18466c709fa5ea2548c935f/hkdf-0.0.3.tar.gz"
    sha256 "622a31c634bc185581530a4b44ffb731ed208acf4614f9c795bdd70e77991dca"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0c/84/e58c665f4ebb03d2fbeb28b51afb0743f846db18a5b594ed8b8973676ddf/humanize-4.8.0.tar.gz"
    sha256 "9783373bf1eec713a770ecaa7c2d7a7902c98398009dfa3d8a2df91eec9311e8"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/86/42/9e87f04fa2cd40e3016f27a4b4572290e95899c6dce317e2cdb580f3ff09/incremental-22.10.0.tar.gz"
    sha256 "912feeb5e0f7e0188e6f42241d2f450002e11bbc0937c65865045854c24c0bd0"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
  end

  resource "service-identity" do
    url "https://files.pythonhosted.org/packages/3b/98/2a46c7414ffc1d06ba67d2c2dd62a207a70cb351028a8cd8c85b3dbd1cf7/service_identity-23.1.0.tar.gz"
    sha256 "ecb33cd96307755041e978ab14f8b14e13b40f1fbd525a4dc78f46d2b986431d"
  end

  resource "spake2" do
    url "https://files.pythonhosted.org/packages/60/0b/bb5eca8e18c38a10b1c207bbe6103df091e5cf7b3e5fdc0efbcad7b85b60/spake2-0.8.tar.gz"
    sha256 "c17a614b29ee4126206e22181f70a406c618d3c6c62ca6d6779bce95e9c926f4"

    # Update versioneer script for 3.12. Remove when merged/released
    # https://github.com/warner/python-spake2/pull/15
    patch do
      url "https://github.com/warner/python-spake2/commit/5079cc963305c8aa6465e2a4bbbb08781fb49d3b.patch?full_index=1"
      sha256 "2e095162aeb910eb5ca399763499b414b400bcf5cf59fd851f5810d7b6d11646"
    end
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/5b/6c/d58b1bfc47cf02bd282f32fee9bd74d834fb2a92fdedf3e56f1ddb778c18/twisted-23.8.0.tar.gz"
    sha256 "3c73360add17336a622c0d811c2a2ce29866b6e59b1125fd6509b17252098a24"
  end

  resource "txaio" do
    url "https://files.pythonhosted.org/packages/51/91/bc9fd5aa84703f874dea27313b11fde505d343f3ef3ad702bddbe20bfd6e/txaio-23.1.1.tar.gz"
    sha256 "f9a9216e976e5e3246dfd112ad7ad55ca915606b60b84a757ac769bd404ff704"
  end

  resource "txtorcon" do
    url "https://files.pythonhosted.org/packages/77/ae/38b568f8daa3d41009688458399bd7a969e2d2d9965f923da3743904e263/txtorcon-23.5.0.tar.gz"
    sha256 "93fd80a9dd505f698d0864fe93db8b6a9c1144b5feb91530820b70ed8982651c"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a4/99/78c4f3bd50619d772168bec6a0f34379b02c19c9cced0ed833ecd021fd0d/wheel-0.41.2.tar.gz"
    sha256 "0c5ac5ff2afb79ac23ab82bab027a0be7b5dbcf2e54dc50efe4bf507de1f7985"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/87/03/6b85c1df2dca1b9acca38b423d1e226d8ffdf30ebd78bcb398c511de8b54/zope.interface-6.1.tar.gz"
    sha256 "2fdc7ccbd6eb6b7df5353012fbed6c3c5d04ceaca0038f75e601060e95345309"
  end

  def install
    # Workaround versioneer script broken on 3.12. Remove on next release.
    # https://github.com/magic-wormhole/magic-wormhole/pull/507
    inreplace "setup.py", "commands = versioneer.get_cmdclass()", "commands = {}"
    inreplace "setup.py", "version=versioneer.get_version(),", "version='#{version}',"

    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
    man1.install "docs/wormhole.1"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    n = rand(1e6)
    pid = fork do
      exec bin/"wormhole", "send", "--code=#{n}-homebrew-test", "--text=foo"
    end
    sleep 1
    begin
      received = shell_output("#{bin}/wormhole receive #{n}-homebrew-test")
      assert_match received, "foo\n"
    ensure
      Process.wait(pid)
    end
  end
end