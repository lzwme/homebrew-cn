class BumpMyVersion < Formula
  include Language::Python::Virtualenv

  desc "Version bump your Python project"
  homepage "https:callowayproject.github.iobump-my-version"
  url "https:files.pythonhosted.orgpackages007081d4f2c9f29e9289951aabf8db8f2fe6372eaa745a340d9f53f1ef91cf2cbump_my_version-0.27.0.tar.gz"
  sha256 "483c517af91559644d45036648e5d99f4f8c85f8d01394097d3d3e42c9e6acad"
  license "MIT"
  head "https:github.comcallowayprojectbump-my-version.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "833e201f782a45281569fb20cb07adb9cebcace9c4e15a64cef3ffae8880baf8"
    sha256 cellar: :any,                 arm64_sonoma:  "d852ced96b2405fd25c8038f105791a72b03865cafc30d562397fd8ff470a3d3"
    sha256 cellar: :any,                 arm64_ventura: "17d0d2e9ae55b325c5d9b4fe5a55482bea0b3643b808a05095f0d5a0a15cf16b"
    sha256 cellar: :any,                 sonoma:        "a3663f4f25e7b576cb9dc8a04772c50a2f689f3971db9cbc3721fb6084f5bd3b"
    sha256 cellar: :any,                 ventura:       "fa2a101d04c76970d47328f9e9ac42bf4f9ba501d63d60aa6e2fe664fb7f5f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e8bf0c499b538a8daa889da80f2ba6c92133a8825b4557393029efcb3d66538"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "bracex" do
    url "https:files.pythonhosted.orgpackagesd66c57418c4404cd22fe6275b8301ca2b46a8cdaa8157938017a9ae0b3edf363bracex-2.5.post1.tar.gz"
    sha256 "12c50952415bfa773d2d9ccb8e79651b8cdb1f31a42f6091b804f6ba2b4a66b6"
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
    url "https:files.pythonhosted.orgpackagesa9b7d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagese2aa6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "pydantic-settings" do
    url "https:files.pythonhosted.orgpackages68270bed9dd26b93328b60a1402febc780e7be72b42847fa8b5c94b7d0aeb6d1pydantic_settings-2.5.2.tar.gz"
    sha256 "f90b139682bee4d2065273d5185d71d37ea46cfe57e1b5ae184fc6a0b2484ca0"
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
    url "https:files.pythonhosted.orgpackagesaa9e1784d15b057b0075e5136445aaea92d23955aad2c93eaede673718a40d95rich-13.9.2.tar.gz"
    sha256 "51a2c62057461aaf7152b4d611168f93a9fc73068f8ded2790f29fe2b5366d0c"
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

  resource "wcmatch" do
    url "https:files.pythonhosted.orgpackages41abb3a52228538ccb983653c446c1656eddf1d5303b9cb8b9aef6a91299f862wcmatch-10.0.tar.gz"
    sha256 "e72f0de09bba6a04e0de70937b0cf06e55f36f37b3deb422dfaf854b867b840a"
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