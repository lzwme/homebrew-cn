class Yamlfix < Formula
  include Language::Python::Virtualenv

  desc "Simple and configurable YAML formatter that keeps comments"
  homepage "https://lyz-code.github.io/yamlfix/"
  url "https://files.pythonhosted.org/packages/55/df/75a9e3d05e56813d9ccc15db39627fc571bb7526586bbfb684ee9f488795/yamlfix-1.18.0.tar.gz"
  sha256 "ae35891e08aa830e7be7abed6ca25e020aa5998551e4d76e2dc8909bf3c35d7e"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e720c2c592f6efb91c0ab63a956de72110017788bb42a3e7d9ec2d988afeea11"
    sha256 cellar: :any,                 arm64_sequoia: "6fb7eae99ec3c289369789bfee26275d62e12a0aeae64ad3657fab8bf5d57a66"
    sha256 cellar: :any,                 arm64_sonoma:  "c5f8d226531fe1558c55a6fbf1bb4b06d20171bcb598638664c19a3c284043c7"
    sha256 cellar: :any,                 sonoma:        "7bec11971ee93f9afc4e28cd72cef317ede224a01a5cb6654e669b3003a777fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3b2b6e086af7d6de8a90400b8f0a9f0441884c1ba97d63246eb2b78ffdfd96f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "153c4438e2255b6bcfbb2fa8d2be85d7e417b412b1b7925d11276db549a36c6b"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "python@3.14"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/3a/05/a1dae3dffd1116099471c643b8924f5aa6524411dc6c63fdae648c4f1aca/loguru-0.7.3.tar.gz"
    sha256 "19480589e77d47b8d85b2c827ad95d49bf31b0dcde16593892eb51dd18706eb6"
  end

  resource "maison" do
    url "https://files.pythonhosted.org/packages/24/45/7cb1d08b6b5674c381b6e0232d35f417a1eba8bb66cdc18edff2b9c80b68/maison-2.0.2.tar.gz"
    sha256 "476f2bf414a20f5abf5a9856bd4db78b5a33c695654a0fc49c3c4abed78c2efc"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/c3/da/b8a7ee04378a53f6fefefc0c5e05570a3ebfdfa0523a878bcd3b475683ee/pydantic-2.12.0.tar.gz"
    sha256 "c1a077e6270dbfb37bfd8b498b3981e2bb18f68103720e51fa6c306a5a9af563"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/7d/14/12b4a0d2b0b10d8e1d9a24ad94e7bbb43335eaf29c0c4e57860e8a30734a/pydantic_core-2.41.1.tar.gz"
    sha256 "1ad375859a6d8c356b7704ec0f547a58e82ee80bb41baa811ad710e124bc8f2f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "ruyaml" do
    url "https://files.pythonhosted.org/packages/4b/75/abbc7eab08bad7f47887a0555d3ac9e3947f89d2416678c08e025e449fdc/ruyaml-0.91.0.tar.gz"
    sha256 "6ce9de9f4d082d696d3bde264664d1bcdca8f5a9dff9d1a1f1a127969ab871ab"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/21/ca/950278884e2ca20547ff3eb109478c6baf6b8cf219318e6bc4f666fad8e8/typer-0.19.2.tar.gz"
    sha256 "9ad824308ded0ad06cc716434705f691d4ee0bfd0fb081839d2e426860e7fdca"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlfix --version")

    (testpath/"test.yaml").write <<~YAML
      foo: bar
      baz: qux
    YAML

    assert_match <<~EOS, shell_output("#{bin}/yamlfix test.yaml 2>&1").gsub(/\e\[\d+m/, "")
      [+] YamlFix: Fixing files
      [+] Fixed test.yaml
      [+] Checked 1 files: 1 fixed, 0 left unchanged
    EOS

    expected_content = <<~YAML
      ---
      foo: bar
      baz: qux
    YAML

    assert_equal expected_content, (testpath/"test.yaml").read
  end
end