class Reuse < Formula
  include Language::Python::Virtualenv

  desc "Tool for copyright and license recommendations"
  homepage "https:reuse.software"
  url "https:files.pythonhosted.orgpackages084335421efe0e69823787b331362e11cc16bb697cd6f19cbed284d421615f14reuse-5.0.2.tar.gz"
  sha256 "878016ae5dd29c10bad4606d6676c12a268c12aa9fcfea66403598e16eed085c"
  license all_of: [
    "GPL-3.0-or-later",
    "CC-BY-SA-4.0",
    "CC0-1.0",
    "Apache-2.0",
  ]
  head "https:github.comfsfereuse-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "435c32f0ed5458f6b1cf78b31a7bdc8bfbb06200259dd5e8118aa411ebb04c44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16db21b6f6e97a7436dda3857890556fc3307ff3007d455e49058ab468b1e4ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c28246a79c8a98e751d9482869f734175a1221bcfa59f865c05c6827cbeb2ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ad7d0a980489ede6cf0eee44fcfac99de765cd4311edd059b88f07fd3e610ec"
    sha256 cellar: :any_skip_relocation, ventura:       "85f04a61780f915a76525107d516e91c40ec29cd8fe667959d74e34adf61e132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "285bccad1dbe8f775264e53482f94827e73df845f74399f0274d69702396adca"
  end

  depends_on "python@3.13"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages497cfdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17fattrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "binaryornot" do
    url "https:files.pythonhosted.orgpackagesa7fe7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49bbinaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "boolean-py" do
    url "https:files.pythonhosted.orgpackagesa2d9b6e56a303d221fc0bdff2c775e4eef7fedd58194aa5a96fa89fb71634cc9boolean.py-4.0.tar.gz"
    sha256 "17b9a181630e43dde1851d42bef546d616d5d9b4480357514597e78b203d06e4"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "license-expression" do
    url "https:files.pythonhosted.orgpackages746f8709031ea6e0573e6075d24ea34507b0eb32f83f10e1420f2e34606bf0dalicense_expression-30.4.1.tar.gz"
    sha256 "9f02105f9e0fcecba6a85dfbbed7d94ea1c3a70cf23ddbfb5adf3438a6f6fce0"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "python-debian" do
    url "https:files.pythonhosted.orgpackagesce8d2ebc549adf1f623d4044b108b30ff5cdac5756b0384cd9dddac63fe53eaepython-debian-0.1.49.tar.gz"
    sha256 "8cf677a30dbcb4be7a99536c17e11308a827a4d22028dc59a67f6c6dd3f0f58c"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesb109a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fatomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"reuse", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath"testfile.rb").write ""
    system bin"reuse", "annotate", "--copyright=Homebrew Maintainers",
                  "--exclude-year",
                  "--license=BSD-2-Clause",
                  testpath"testfile.rb"
    header = <<~RUBY
      # SPDX-FileCopyrightText: Homebrew Maintainers
      #
      # SPDX-License-Identifier: BSD-2-Clause
    RUBY
    assert_equal header, (testpath"testfile.rb").read
    system bin"reuse", "download", "BSD-2-Clause"
    assert_path_exists testpath"LICENSESBSD-2-Clause.txt"
  end
end