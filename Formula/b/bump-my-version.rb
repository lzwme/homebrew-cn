class BumpMyVersion < Formula
  include Language::Python::Virtualenv

  desc "Version bump your Python project"
  homepage "https:callowayproject.github.iobump-my-version"
  url "https:files.pythonhosted.orgpackagese74f57eda33958c5820b462c4c262bc18dc374dca6312bbb63f95606172200cbbump_my_version-0.30.0.tar.gz"
  sha256 "d53e784c73abc4bb5759e296f510bc71878e1df078eb525542ec9291b5ceb195"
  license "MIT"
  head "https:github.comcallowayprojectbump-my-version.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5eb13d41ed3debff0ee332cea29e37f443a963c5df353af04b5d04c837ac73ae"
    sha256 cellar: :any,                 arm64_sonoma:  "7cda84317370741936cd73efb21ee7a98a37f64680c3b968466d5165348e7601"
    sha256 cellar: :any,                 arm64_ventura: "3bb375bb94572a9da25eb9da46c59f80da2b7e64d07a75525b1c781ca7a42574"
    sha256 cellar: :any,                 sonoma:        "a63c5466ee5f975bfccdf4b51291ef959f67a0526b041c9599ec9ccc1ae56c0a"
    sha256 cellar: :any,                 ventura:       "5d0d175cb09c26146558b081931d29303e7b5f224d51b07832554f8567b6b2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cab2b5be2e5ae9b4a850c7d2ed4223dd52ecd761ba9ca8f7fa5b1e7f1267e85"
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
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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
    url "https:files.pythonhosted.orgpackagesa1e1bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesb7aed5220c5c52b158b1de7ca89fc5edb72f304a70a4c540c84c8844bf4008depydantic-2.10.6.tar.gz"
    sha256 "ca5daa827cce33de7a42be142548b0096bf05a7e7b365aebfa5f8eeec7128236"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesfc01f3e5ac5e7c25833db5eb555f7b7ab24cd6f8c322d3a3ad2d67a952dc0abcpydantic_core-2.27.2.tar.gz"
    sha256 "eb026e5a4c1fee05726072337ff51d1efb6f59090b7da90d30ea58625b1ffb39"
  end

  resource "pydantic-settings" do
    url "https:files.pythonhosted.orgpackages737bc58a586cd7d9ac66d2ee4ba60ca2d241fa837c02bca9bea80a9a8c3d22a9pydantic_settings-2.7.1.tar.gz"
    sha256 "10c9caad35e64bfb3c2fbf70a078c0e25cc92499782e5200747f942a065dec93"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesbc57e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "questionary" do
    url "https:files.pythonhosted.orgpackagesa8b8d16eb579277f3de9e56e5ad25280fab52fc5774117fb70362e8c2e016559questionary-2.1.0.tar.gz"
    sha256 "6302cdd645b19667d8f6e6634774e9538bfcd1aad9be287e743d96cacaf95587"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rich-click" do
    url "https:files.pythonhosted.orgpackages9a31103501e85e885e3e202c087fa612cfe450693210372766552ce1ab5b57b9rich_click-1.8.5.tar.gz"
    sha256 "a3eebe81da1c9da3c32f3810017c79bd687ff1b3fa35bfc9d8a3338797f1d1a1"
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

    generate_completions_from_executable(bin"bump-my-version", shells: [:fish, :zsh], shell_parameter_format: :click)
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