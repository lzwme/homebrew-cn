class Mentat < Formula
  include Language::Python::Virtualenv

  desc "Coding assistant that leverages GPT-4 to write code"
  homepage "https://www.mentat.ai"
  url "https://files.pythonhosted.org/packages/30/17/44f082cf6f87e09924c0761c05b0a0331c96e6eaff87e097504a6b816c8e/mentat-1.0.4.tar.gz"
  sha256 "74b78f79da5587ec1ba76b7079634d57ed09fc339bf5bb574a92f47f8d7556ae"
  license "Apache-2.0"
  head "https://github.com/AbanteAI/mentat.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7b630121d657b10c0baaaf7413ad1d060b84a44acc163eb59fcc18ddd99b7e2"
    sha256 cellar: :any,                 arm64_ventura:  "6482b9c2ce6638ea7da4e2dc5c75ee3329795ee4d11b953a4350be3ec1e05ff2"
    sha256 cellar: :any,                 arm64_monterey: "62b8a9332ac48c3697d3d3d2eb2e6473e664c23b88893269f25ae781cde74e28"
    sha256 cellar: :any,                 sonoma:         "f21c27a0ef8824b17d6f2041122e5a9d0218ad2108490f0426d10deb314bb862"
    sha256 cellar: :any,                 ventura:        "0a58e17e54325424eba34897a7b3047b54b88f1e0cd107f917bdfbe83bf96663"
    sha256 cellar: :any,                 monterey:       "f207209f421615ca390878d5ee360bb41574c46604f05d819150b657c10ecfdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06f1e2fff72d99f70aa751fae272290503b6c59f5b1aeabaaa9f17d59ee247e0"
  end

  depends_on "rust" => :build # for tiktoken
  depends_on "numpy"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-jinja"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/28/99/2dfd53fd55ce9838e6ff2d4dac20ce58263798bd1a0dbe18b3a9af3fcfce/anyio-3.7.1.tar.gz"
    sha256 "44a3c9aba0f5defa43261a8b3efb97891f2bd7d804e0e1f56419befa1adfc780"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "fire" do
    url "https://files.pythonhosted.org/packages/94/ed/3b9a10605163f48517931083aee8364d4d6d3bb1aa9b75eb0a4a5e9fbfc1/fire-0.5.0.tar.gz"
    sha256 "a6b0d49e98c8963910021f92bba66f65ab440da2982b78eb1bbf95a0a34aacc6"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/18/56/78a38490b834fa0942cbe6d39bd8a7fd76316e8940319305a98d2b320366/httpcore-1.0.2.tar.gz"
    sha256 "9fc092e4799b26174648e54b74ed5f683132a464e95643b226e00c2ed2fa6535"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/8c/23/911d93a022979d3ea295f659fbe7edb07b3f4561a477e83b3a6d0e0c914e/httpx-0.25.2.tar.gz"
    sha256 "8b8fcaa0c8ea7b05edd69a094e63a2094c4efcb48129fb757361bc423c0ad9e8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/1c/3c/a92cf8844ec4bf3211a42926ed5cab72f18d32bb3a0155a759783b38d6b5/openai-1.3.0.tar.gz"
    sha256 "51d9ccd0611fd8567ff595e8a58685c20a4710763d42f6bd968e1fb630993f25"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b7/41/3c8108f79fb7da2d2b17f35744232af4ffcd9e764ebe1e3fd4b26669b325/pydantic-2.5.2.tar.gz"
    sha256 "ff177ba64c6faf73d7afa2e8cad38fd456c0dbe01c9954e71038001cd15a6edd"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/64/26/cffb93fe9c6b5a91c497f37fae14a4b073ecbc47fc36a9979c7aa888b245/pydantic_core-2.14.5.tar.gz"
    sha256 "6d30226dfc816dd0fdf120cae611dd2215117e4f9b124af8c60ab9093b6e8e71"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/a7/f3/dadfbdbf6b6c8b5bd02adb1e08bc9fbb45ba51c68b0893fa536378cdf485/pytest-7.4.0.tar.gz"
    sha256 "b4bf8c45bd59934ed84001ad51e11b4ee40d40a1229d2c79f9c592b0a3f6bd8a"
  end

  resource "pytest-asyncio" do
    url "https://files.pythonhosted.org/packages/5a/85/d39ef5f69d5597a206f213ce387bcdfa47922423875829f7a98a87d33281/pytest-asyncio-0.21.1.tar.gz"
    sha256 "40a7eae6dded22c7b604986855ea48400ab15b069ae38116e8c01238e9eeb64d"
  end

  resource "pytest-mock" do
    url "https://files.pythonhosted.org/packages/d8/2d/b3a811ec4fa24190a9ec5013e23c89421a7916167c6240c31fdc445f850c/pytest-mock-3.11.1.tar.gz"
    sha256 "7f6b125602ac6d743e523ae0bfa71e1a697a2f5534064528c6ff84c2f7c2fc7f"
  end

  resource "pytest-reportlog" do
    url "https://files.pythonhosted.org/packages/da/a0/d1372b23d415a0766389480633a676fb1530e94ae8f6ea84619cae0ac215/pytest-reportlog-0.4.0.tar.gz"
    sha256 "c9f2079504ee51f776d3118dcf5e4730f163d3dcf26ebc8f600c1fa307bf638c"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/31/06/1ef763af20d0572c032fa22882cfbfb005fba6e7300715a37840858c919e/python-dotenv-1.0.0.tar.gz"
    sha256 "a8df96034aae6d2d50a4ebe8216326c61c3eb64836776504fcca410e5937a3ba"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/6b/38/49d968981b5ec35dbc0f742f8219acab179fc1567d9c22444152f950cf0d/regex-2023.10.3.tar.gz"
    sha256 "3fef4f844d2290ee0ba57addcec17eec9e3df73f10a2748485dfd6a3a188cc0f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/00/e5/cf944fd98a68dcde5567949061322577200222d4a897a471e8eaafdbaed4/sentry-sdk-1.34.0.tar.gz"
    sha256 "e5d0d2b25931d88fa10986da59d941ac6037f742ab6ff2fce4143a27981d60c3"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/9f/88/77a86f915a81449156375b7538c94105a34bebf00838462c9d3fced490e9/tiktoken-0.4.0.tar.gz"
    sha256 "59b20a819969735b48161ced9b92f05dc4519c17be4015cfb73b65270a243620"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Run mentat and capture stderr
    output = shell_output("#{bin}/mentat 2>&1", 1)
    assert_match "isn't part of a git project", output
  end
end