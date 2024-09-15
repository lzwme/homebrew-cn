class BumpMyVersion < Formula
  include Language::Python::Virtualenv

  desc "Version bump your Python project"
  homepage "https:callowayproject.github.iobump-my-version"
  url "https:files.pythonhosted.orgpackages64e879b34e1be514aea34182a766ab9ae1fdb493ce0e36609517c3dd10adf3f7bump_my_version-0.26.1.tar.gz"
  sha256 "af1cada726cf6f9a723d18941c68c325d5196453a180b3a42f8e0b38567d734d"
  license "MIT"
  head "https:github.comcallowayprojectbump-my-version.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ac3f433f9fee76693e2e2cb22551ea513b9cbb1137932717b1180183effca8de"
    sha256 cellar: :any,                 arm64_sonoma:  "e0cbd4d44808f8edf927d7661999bc24e342afd7e35088c371a274fab961a9b3"
    sha256 cellar: :any,                 arm64_ventura: "d7bcf84c3f5813589cde8db10c9d31e413749d4ce55411de19af452c3101be97"
    sha256 cellar: :any,                 sonoma:        "3d0ed872bbfb908e823dc937aaf77626a087e2101c3d23c3307ff05fff16114f"
    sha256 cellar: :any,                 ventura:       "fa5ecaa580f8879e31cc8ea0adbe5ec915d8a51673c910562a50afe4b91c939c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc45736aee4c4ce7440c10b9d3fcb5ca2e857cc8f2e38b823746f339e04a20b7"
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
    url "https:files.pythonhosted.orgpackages14153d989541b9c8128b96d532cfd2dd10131ddcc75a807330c00feb3d42a5bdpydantic-2.9.1.tar.gz"
    sha256 "1363c7d975c7036df0db2b4a61f2e062fbc0aa5ab5f2772e0ffc7191a4f4bce2"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages5ccc07bec3fb337ff80eacd6028745bd858b9642f61ee58cfdbfb64451c1def0pydantic_core-2.23.3.tar.gz"
    sha256 "3cb0f65d8b4121c1b015c60104a685feb929a29d7cf204387c7f2688c7974690"
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
    url "https:files.pythonhosted.orgpackages927640f084cb7db51c9d1fa29a7120717892aeda9a7711f6225692c957a93535rich-13.8.1.tar.gz"
    sha256 "8260cda28e3db6bf04d2d1ef4dbc03ba80a824c88b0e7668a0f23126a424844a"
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