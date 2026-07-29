class MailDeduplicate < Formula
  include Language::Python::Virtualenv

  desc "CLI to deduplicate mails from mail boxes"
  homepage "https://kdeldycke.github.io/mail-deduplicate/"
  url "https://files.pythonhosted.org/packages/eb/55/7c0403d149046cbdfcaebe2299454d0bc4d33e6ac41f8651a8cc9fbe48d5/mail_deduplicate-9.0.0.tar.gz"
  sha256 "86d6d116b0d07a0308c03f74b4f138df2db221c72ca8bb9e9922010570bea5a0"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/mail-deduplicate.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b1e1066b7fcd72b244a1064d87544c9487e044b275f15729959d20079aa4f6be"
    sha256 cellar: :any, arm64_sequoia: "b5190d1a0cc2c53667539f59f104b609be984862b5a72498c488b8c8571d9254"
    sha256 cellar: :any, arm64_sonoma:  "3321f52502360831f568d6b451e689b4ef1d7d04a93bb126c0400f725088eb9f"
    sha256 cellar: :any, sonoma:        "968c8d03488625c8f8552c86e3ea00cb0fa5153c06fb0f24530cf70c228fe3e6"
    sha256 cellar: :any, arm64_linux:   "521a935de287665df635a0a2dfae4ee40f01e7eb96eb34029fb5a5bda86c1365"
    sha256 cellar: :any, x86_64_linux:  "52f724a00a9032a46bb0d3a30c0cb33e3598495a9e74bc49a53a2f8e529c0ba6"
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
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/60/2f/27d20ac136d08bc95a759fb7c503a2d4cb3391461b9fb33ff32f1ddd014a/click_extra-8.6.0.tar.gz"
    sha256 "63f739447522a6aa2d64d656aeb0f967826f2dfba774fc76e117b84717853733"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/42/ca/cf02e965cfeb70d65c61fd3abb8022aaf5111a0de71b3c73a6ec2113aa25/cloup-3.1.0.tar.gz"
    sha256 "637c1e628fe98f3f20a5e44da591a72b42bf54d7d4527190bf39ed5f64af7585"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/2a/78/6e9e20106224083cfb817d2d3c26e80e72258d617b616721a169b87081e0/deepmerge-2.1.0.tar.gz"
    sha256 "07ca7a7b8935df596c512fa8161877c0487ac61f691c07766e7d71d2b23bdd2f"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/be/e3/b04ca89a5b48424fc7df7dc4131ea4ffd8efa8788590163c2f777a02b959/extra_platforms-13.4.0.tar.gz"
    sha256 "d3d07e1afeaa9cdd9c6c4b716e81c2b18c7af1b6d68c157c1b339b31f6597903"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/16/25/1da725838132221e33568973da484ff43813662ccc06ebf7f6e3abddfcd5/wcmatch-11.0.tar.gz"
    sha256 "55d95c2447789712774b198ceec72939e88b5618f1f8f0a9b605bf7740b63b96"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  resource "whenever" do
    url "https://files.pythonhosted.org/packages/6d/40/94856fe2439c4b8162d1a23b4cf3a48bb00bed0ed7b8d10add40988fa555/whenever-0.10.3.tar.gz"
    sha256 "af8958c870bd178742f0089c3552d5702241cab1f4b6bdfd3b03111db4bc2150"
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