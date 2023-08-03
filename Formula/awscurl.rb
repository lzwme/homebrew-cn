class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/80/f4/95935ad7041ba008221ce81b698963c8be0c5c97e6fcfd86e0e2009ebacd/awscurl-0.29.tar.gz"
  sha256 "5e1ecd0ab7b014de697a1e161fa483c2263d16c3e156a81bdc8b9a9c2d0ba3f3"
  license "MIT"
  revision 4
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "43ea14dc5fe301ab8218ae8605d29b041598a322a69b7ce27181def25abd7f71"
    sha256 cellar: :any,                 arm64_monterey: "eff9f75ac69d93762f980e4a9df6fc262de777c75a2f5b3d073b36c4f05d67f1"
    sha256 cellar: :any,                 arm64_big_sur:  "55c09423ca299f86717726a808ccb578b89b987025dbfc00c9eda09be37ebf07"
    sha256 cellar: :any,                 ventura:        "0d25a1be9d35981928d73773602ec9c96ad6b9ee1a03679dd0c6ee18e4d7e3d0"
    sha256 cellar: :any,                 monterey:       "676719d19e85a0456a2f8df59a9faf32ec3c8b24e8a161ffd0b11e84c1c4b56e"
    sha256 cellar: :any,                 big_sur:        "fdeba2f5bb4566e317230dfc70dcf3c715c75c73bfb46ccd7115344657043165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cda9f123135472bd298ee5a1157e0008e0dc10f5d6aa938788f25b521dcd4dff"
  end

  # `pkg-config`, `rust` and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "libffi"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/0b/65/bad3eb64f30657ee9fa2e00e80b3ad42037db5eb534fadd15a94a11fe979/configparser-6.0.0.tar.gz"
    sha256 "ec914ab1e56c672de1f5c3483964e68f71b34e457904b7b76e06b922aec067a8"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/8e/5d/2bf54672898375d081cb24b30baeb7793568ae5d958ef781349e9635d1c8/cryptography-41.0.3.tar.gz"
    sha256 "6d192741113ef5e30d89dcb5b956ef4e1578f304708701b8b73d38e3e1461f34"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "urllib3-secure-extra" do
    url "https://files.pythonhosted.org/packages/c9/67/76b7c055ea787729bb9f839a84689ea2f88e217519d59ae547824431ec95/urllib3-secure-extra-0.1.0.tar.gz"
    sha256 "ee9409cbfeb4b8609047be4c32fb4317870c602767e53fd8a41005ebe6a41dff"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    assert_match "Curl", shell_output("#{bin}/awscurl --help")

    assert_match "No access key is available",
      shell_output("#{bin}/awscurl --service s3 https://homebrew-test-non-existent-bucket.s3.amazonaws.com 2>&1", 1)
  end
end