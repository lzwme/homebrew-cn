class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/ab/9e/d548d093461b4a9b416672a5dbca3941ab01485a013f4c75018ec0df5b86/translate_toolkit-3.17.4.tar.gz"
  sha256 "4f01267918cd20c866f71f8b8acaeb5288c054793d9ba135339f59707e49a124"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a0a8f51c092e6404648d23a272c07e4aa3002d4f716cf8e300bd2c28083fd00"
    sha256 cellar: :any,                 arm64_sequoia: "93b6abe8bc0773bc39f2a9ec5d285da287142222417c4ea46f5b9cf5e656987e"
    sha256 cellar: :any,                 arm64_sonoma:  "56289675b81ad264646f27ef602155d9275d72c47df79a96fb217ab88e72bdfe"
    sha256 cellar: :any,                 sonoma:        "7a71cf448fc736663e9111a0e66e3a38a8dfcc4d2dd11d146e469eb13cdcddd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "230a5d7dd24274034d813557588d16e1f67b392b7ed6ef7fc37cfd9727c2108a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "109ecf23408fcdd005b592aa834abe8272b9a3aa501876fffeafdfdbddbc7cc5"
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