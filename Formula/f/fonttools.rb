class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/5a/96/686339e0fda8142b7ebed39af53f4a5694602a729662f42a6209e3be91d0/fonttools-4.62.0.tar.gz"
  sha256 "0dc477c12b8076b4eb9af2e440421b0433ffa9e1dcb39e0640a6c94665ed1098"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "277d614e17a42ca9ae60dbd581e7b6bedf13919243c8c125a9f344ef43d266c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1d30275d55f2f3a20cbaceb2809d33d7269376e54c8d5334197eb81363f7d83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ad083713fe7c6d36fd4e54b2a0b92ef204175274c26df364f73090772c218f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "778e50ef18006d176875d66ff2e19446b85f3d6617966f1db9fe68d8ce5bff58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf8962ce8b2d5adf6e28fd0a445ed39aeeb2ee7a81bcaa5365fdb212037b5454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c3049d66ea8599f45dfb2c06dd5ffd86ca5b94e06c40d8976612ade3a1004bb"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  pypi_packages package_name: "fonttools[lxml,woff]"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "zopfli" do
    url "https://files.pythonhosted.org/packages/0a/4d/a8cc1768b2eda3c0c7470bf8059dcb94ef96d45dd91fc6edd29430d44072/zopfli-0.4.1.tar.gz"
    sha256 "07a5cdc5d1aaa6c288c5d9f5a5383042ba743641abf8e2fd898dcad622d8a38e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    if OS.mac?
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath

      system bin/"ttx", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.ttx"
      system bin/"fonttools", "ttLib.woff2", "compress", "ZapfDingbats.ttf"
      assert_path_exists testpath/"ZapfDingbats.woff2"
    else
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end