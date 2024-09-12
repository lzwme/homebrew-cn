class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "https://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/93/75/414f33186846444da53b4e834d5ccfb0577d0e09b997819c183fa509f70a/coconut-3.1.2.tar.gz"
  sha256 "ef0656ee2df4594007f998f4a9c2a1b9bfbc40541a400cbaa00ccbbac50e5414"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f40d1201b9b52e5ef52b03102febee1add7119a7091bd9313b068ffe4ff62556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caf2ac1e1c6f0aed297ef0b9af1c49a8968c0cf4cfd8230e0b7e2cc618ae3090"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e31ea818db43d09baa443fe2af11f981a1b2e625c88b629e1eef957bf05663a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f97665b22bc5843e14c962ab685060b8eefb776ebfa14cfb01ff573ee5d8cf09"
    sha256 cellar: :any_skip_relocation, sonoma:         "02c14e4de3171dcb73d5308375a2dd5b23f2edbf435685033235c8ba5e5a8b69"
    sha256 cellar: :any_skip_relocation, ventura:        "2f950454d298751f88015943d97e7dd4bc504c254aa3d70946c9e8a3e31f94c4"
    sha256 cellar: :any_skip_relocation, monterey:       "0ed68359bcf643eb9a67817660a59e2fbcf0c0b56ad9b0f072f6484a6ead0f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bb84dd30519e83e8af41fd21ca1e4ec7df8562bee1e45a08575fa85e5b907b7"
  end

  depends_on "python@3.12"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/e6/e3/c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2/anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/74/fe/7d45fc7fb67dd3cdaef4430c882b0b655e18ca45cf792d5feefb15f18ca2/cpyparsing-2.4.7.2.4.0.tar.gz"
    sha256 "ee3d2f262712ad252a640131687d1b25985127a5d9ba2e1200f3017165f2ee7d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/e8/ac/e349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72a/idna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/47/6d/0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879f/prompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6a/21/8fd457d5a979109603e0e460c73177c3a9b6b7abcd136d0146156da95895/setuptools-74.0.0.tar.gz"
    sha256 "a85e96b8be2b906f3e3e789adec6a9323abf79758ecfa3065bd740d81158b11e"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end