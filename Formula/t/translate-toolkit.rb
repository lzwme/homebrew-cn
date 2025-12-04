class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/dd/d1/14615bfc47e38d848c98e7901576f929042b1144e1dc66a93c477b6569a7/translate_toolkit-3.17.3.tar.gz"
  sha256 "05601dc3027096b3b0de831bb44b602eb923c4483bcc5a19cc82d55785bc8416"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c6514ec137594ddaf88871633981a33a32c523198fe5e678debdf75ebf37307"
    sha256 cellar: :any,                 arm64_sequoia: "a470aaa86f14c91ac1351bfde7312c99d487f5f8f38edf830a1984ad514a297a"
    sha256 cellar: :any,                 arm64_sonoma:  "5f12de216cf29837d5695882923a42855537b1ae163b50b87ebaca1f8030b6b8"
    sha256 cellar: :any,                 sonoma:        "8ac4c1a7c71734024699f7a30b36449f51ee922d043980d67c55cd74db43f527"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e706d605da3cec48261be26975a53d1aaaab10a2d895c96cb1dd5fcc7ec30f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6cbb1ed3af9e38eb1eebf4417e51e75c27041889b4e446e71e39e9242693c0f"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/6e/47/ef80c65deddbbc38ec2806b068430dc5052b906c5cee19cab3013ae631ff/unicode_segmentation_rs-0.2.0.tar.gz"
    sha256 "137246f8ccadf249e4978503a88438de68205d89bf360ddeece340938c33caec"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end