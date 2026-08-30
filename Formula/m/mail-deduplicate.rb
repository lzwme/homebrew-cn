class MailDeduplicate < Formula
  include Language::Python::Virtualenv

  desc "CLI to deduplicate mails from mail boxes"
  homepage "https://kdeldycke.github.io/mail-deduplicate/"
  url "https://files.pythonhosted.org/packages/93/6f/74c987273c00163db2ea828f6e7a2e545605bce9608cf7d25ead5a1a0db0/mail_deduplicate-9.3.1.tar.gz"
  sha256 "4e7968e0caef32635e9ed0198e795928c8728e8f6055064023a47fe29c883f59"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/mail-deduplicate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57703fc7c9f2a2f3c7e1eed80bcc955dc229e2175b5693d5d2cbca182addd2c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57703fc7c9f2a2f3c7e1eed80bcc955dc229e2175b5693d5d2cbca182addd2c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57703fc7c9f2a2f3c7e1eed80bcc955dc229e2175b5693d5d2cbca182addd2c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c9cc70f9ed98c3825498e4bfbaf0dfb93c71b6db03df5943c28eb2b88bc3505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c9cc70f9ed98c3825498e4bfbaf0dfb93c71b6db03df5943c28eb2b88bc3505"
  end

  depends_on "rust" => :build # for click_extra > uv_build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/47/99/12bace94ae2ba961bdc46d49277ff15d38dba074bc3987b0c0b4355a37a7/boltons-26.1.0.tar.gz"
    sha256 "5764468aba493b15995ed17f46a16789023f123ca2a62d491a9ce825c1cbe26c"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/ac/01/5f394b8bcd6e5b92f73130990960423bbb19711f906bd9fe9ea5557c667c/bracex-3.0.1.tar.gz"
    sha256 "4e38e32392e4a4780fe15d644bfc7c8514057cfc3861e060b11814ce829c25e4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/fd/59/f527fbd7c2d36c057073900b69da480d928f2d91840d08dcf80929512c81/click_extra-8.9.1.tar.gz"
    sha256 "18a99d91d94375aaa27dc6a5efdebf6cb0cd0637bae49fd1cb6d8a6398cf8294"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/42/ca/cf02e965cfeb70d65c61fd3abb8022aaf5111a0de71b3c73a6ec2113aa25/cloup-3.1.0.tar.gz"
    sha256 "637c1e628fe98f3f20a5e44da591a72b42bf54d7d4527190bf39ed5f64af7585"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/b7/6c/9f4577a36d5f463a3a3f8322bd65d33e1a1a6b6ba1d692a5ebc3cba19015/deepmerge-3.0.tar.gz"
    sha256 "14ed69f063de64b7743985c732ccff5d6c34ff4560946e7fbfd99086b853b9ce"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/3d/e1/01785853e8f1b1029b7417f4ca057ff1c58690e7e8bd97f2e79c101287ab/extra_platforms-13.7.0.tar.gz"
    sha256 "888437802eb1734de914c1dce062371c1c942acdddbfa0b94dd04be99eec0240"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ea/06/cf1564dcc2e2261c8c8c6c05628dc8b418943bdae2a4e58640ceb2f770fa/platformdirs-4.11.5.tar.gz"
    sha256 "e8b31f4f8bcbbedef91a6b57a706255e4f148d2a4e01648382a0a47342539173"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/57/43/30e407989e313677dbb9d5f045f966549a7254834571e342eaa4b55cc67b/wcmatch-11.0.1.tar.gz"
    sha256 "1ea2b4fa678b8ca268253798d5963935df39132d47c3e241c0a0732224005e7d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mdedup", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdedup --version")

    (testpath/"test_mail1.eml").write <<~EOS
      From: sender1@example.com
      To: recipient@example.com
      Subject: Test Email 1

      This is a test email 1.
    EOS

    (testpath/"test_mail2.eml").write <<~EOS
      From: sender2@example.com
      To: recipient@example.com
      Subject: Test Email 2

      This is a test email 2.
    EOS

    # Run mail-deduplicate to check functionality
    output = shell_output("#{bin}/mdedup --dry-run " \
                          "--export=#{testpath}/deduped_mail.mbox test_mail1.eml test_mail2.eml 2>&1")
    assert_match "No mail selected to perform action on", output
  end
end