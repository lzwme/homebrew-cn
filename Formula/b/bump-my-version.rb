class BumpMyVersion < Formula
  include Language::Python::Virtualenv

  desc "Version bump your Python project"
  homepage "https:callowayproject.github.iobump-my-version"
  url "https:files.pythonhosted.orgpackagesf334926646fa7d1c91b8ae215766b88370bea06cf95658fc5eba08b6853cd782bump_my_version-0.26.0.tar.gz"
  sha256 "9e2c01b7639960379440c4a371b3c8c0aa66cf6979985f1c9ba2e7c2fb4a185f"
  license "MIT"
  head "https:github.comcallowayprojectbump-my-version.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ccf2dcd29dd6b6fbff3955d01cbe071a67572043b950cd47df46bfbf50515c47"
    sha256 cellar: :any,                 arm64_sonoma:   "eb9b60bcbfaae7d915fbffb7ca4e137a06a348c85ee3bf1c7a77871ca7f0f542"
    sha256 cellar: :any,                 arm64_ventura:  "bc10e444f39e05ea5d1357af7a7a806d0b1281d8a2e2522b5694d161d5d14bf7"
    sha256 cellar: :any,                 arm64_monterey: "ce49ee9909ba6b67358d1196743e7fab52e80f3314871491d21f7679275b5665"
    sha256 cellar: :any,                 sonoma:         "65c70f9be349e59008a69ab1fa848a044558049d572818c289bb1dd9795b0169"
    sha256 cellar: :any,                 ventura:        "462821fad6fc0302611bf86f0b496a4cc98be37c360da4ca463349b334ef8a6b"
    sha256 cellar: :any,                 monterey:       "b021974631e6dd0875520e5b49a416117207d0156fb2831e091fe5a61a03e490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6194e69948f22bc790b0ac42bcac0df19622d97c1439242c5b3531c35643d0e"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "bracex" do
    url "https:files.pythonhosted.orgpackagesacf1ac657fd234f4ee61da9d90f2bae7d6078074de2f97cb911743faa8d10a91bracex-2.5.tar.gz"
    sha256 "0725da5045e8d37ea9592ab3614d8b561e22c3c5fde3964699be672e072ab611"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesfb93180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesf68f3b9f7a38caa3fa0bcb3cea7ee9958e89a9a6efc0e6f51fd6096f24cac140pydantic-2.9.0.tar.gz"
    sha256 "c7a8a9fdf7d100afa49647eae340e2d23efa382466a8d177efcd1381e9be5598"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages5f0354e4961dfaed4804fea0ad73e94d337f4ef88a635e73990d6e150b469594pydantic_core-2.23.2.tar.gz"
    sha256 "95d6bf449a1ac81de562d65d180af5d8c19672793c81877a2eda8fde5d08f2fd"
  end

  resource "pydantic-settings" do
    url "https:files.pythonhosted.orgpackages58147bfb313ccee79f97dc235721b035174af94ef4472cfe455c259cd2971f2fpydantic_settings-2.4.0.tar.gz"
    sha256 "ed81c3a0f46392b4d7c0a565c05884e6e54b3456e6f0fe4d8814981172dc9a88"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesbc57e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "questionary" do
    url "https:files.pythonhosted.orgpackages84d0d73525aeba800df7030ac187d09c59dc40df1c878b4fab8669bdc805535dquestionary-2.0.1.tar.gz"
    sha256 "bcce898bf3dbb446ff62830c86c5c6fb9a22a54146f0f5597d3da43b10d8fc8b"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagescf605959113cae0ce512cf246a6871c623117330105a0d5f59b4e26138f2c9ccrich-13.8.0.tar.gz"
    sha256 "a5ac1f1cd448ade0d59cc3356f7db7a7ccda2c8cbae9c7a90c28ff463d3e91f4"
  end

  resource "rich-click" do
    url "https:files.pythonhosted.orgpackages3aa9a1f1af87e83832d794342fbc09c96cc7cd6798b8dfb8adfbe6ccbef8d70crich_click-1.8.3.tar.gz"
    sha256 "6d75bdfa7aa9ed2c467789a0688bc6da23fbe3a143e19aa6ad3f8bac113d2ab3"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesb109a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fatomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages745be025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "wcmatch" do
    url "https:files.pythonhosted.orgpackages5590a29d5b359c128c48e32a2dc161464d6aab822df82d3bf1c1286231eda3c2wcmatch-9.0.tar.gz"
    sha256 "567d66b11ad74384954c8af86f607857c3bdf93682349ad32066231abd556c92"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["COLUMNS"] = "80"
    assert_equal "bump-my-version, version #{version}", shell_output("#{bin}bump-my-version --version").chomp

    version_file = testpath"VERSION"
    version_file.write "0.0.0"
    system bin"bump-my-version", "bump", "--current-version", "0.0.0", "minor", version_file
    assert_match "0.1.0", version_file.read
    system bin"bump-my-version", "bump", "--current-version", "0.1.0", "patch", version_file
    assert_match "0.1.1", version_file.read
    system bin"bump-my-version", "bump", "--current-version", "0.1.1", "major", version_file
    assert_match "1.0.0", version_file.read
  end
end