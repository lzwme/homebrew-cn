class MailDeduplicate < Formula
  include Language::Python::Virtualenv

  desc "CLI to deduplicate mails from mail boxes"
  homepage "https://kdeldycke.github.io/mail-deduplicate/"
  url "https://files.pythonhosted.org/packages/b5/21/8ba034c701b146720babedf9e94f9e4dd262f096660067dcf316cce8c1ea/mail_deduplicate-9.4.0.tar.gz"
  sha256 "07a13b614d71d29fe573bd3c048629123ce1f69cd2475c28217f76ffd217458c"
  license "GPL-2.0-or-later"
  head "https://github.com/kdeldycke/mail-deduplicate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b15f200016e5ca84d0a05acabbea7affcdd95e86249e9e602d04c77ec008fd7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "daba7b77e79db4c2152867498ee4df50cc7353007fa8b85a76864675e787abcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a619eae4d700b8f276be0d455f6977b9007b6c1cbb47de9f67c922d530c3140"
    sha256 cellar: :any,                 arm64_linux:       "d0e7fb22487cbab952062e5d31749f4975dc99a6dd8f11011735d8abc4c0887d"
    sha256 cellar: :any,                 x86_64_linux:      "acde4235fddfe5a72a5b6801edb2933a4931fe0aa870091e820a595f10298a13"
  end

  depends_on "rust" => :build # for click_extra > uv_build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/71/56/14c4a4931910a81ddeccfbe227925ea738e3c445d3e2af960f0bcbba1616/boltons-26.2.0.tar.gz"
    sha256 "d39cfd15c1a1c3bd4d705c82252fa9edb8e4f5e8cc039f8e39afac7b1b47e92c"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/fb/37/adf8dd2cde958c2d086bdd87fc36b532fd824bf38f10be6348d65da0c8f9/bracex-3.2.tar.gz"
    sha256 "0a3d40bfae4caae4d3bfd0ea715874799fab711c38fd4012cc35343e815405cd"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-extra" do
    url "https://files.pythonhosted.org/packages/94/49/8f08a9dcff02255ade9898d7972e07a0e227b4151e040baac7c6499c4d07/click_extra-9.5.0.tar.gz"
    sha256 "d3187fddf72c3f2cffc0c38d345e3bdbec989a7b790a5fec473d85cd4d497943"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/05/e2/d41446c6195eff0db3b671ddb202e39f42f9ea7c0dd15cd43fbf5cf0d7f7/cloup-4.0.0.tar.gz"
    sha256 "83b0870ee863bcc85129e40e1b208bcfdebe4cd2142e9ce1d0daf7d276cab038"
  end

  resource "deepmerge" do
    url "https://files.pythonhosted.org/packages/ca/e9/5e99e56e03f9461858e686fdaf82e2516671bc1bd46f8b7ad7b9a8375f6f/deepmerge-4.0.0.tar.gz"
    sha256 "948565f2bc9cdb41259a4a23d26638e5840c9e084a343ab279ffd3edcfdf74d3"
  end

  resource "extra-platforms" do
    url "https://files.pythonhosted.org/packages/3e/2f/c8f34db12c09070b47885d51e4f5cf722107442c3c423cb9a1eb5ec7047a/extra_platforms-13.13.0.tar.gz"
    sha256 "77f9927d5c3ca286241ccba049d4ac6d8256e3df123779e036148fc94d0ff583"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/bd/07/b7a9162a804bc0f7d03fe84c93e374d3e1c4d828043d5f9b797f7d4e30e0/wcmatch-11.2.tar.gz"
    sha256 "1605bde546fbde4c063628c7d89eda486909fd4337e51d73a873987fbcb2554c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
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