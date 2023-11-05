class Jrnl < Formula
  include Language::Python::Virtualenv

  desc "Command-line note taker"
  homepage "https://jrnl.sh/en/stable/"
  url "https://files.pythonhosted.org/packages/b6/65/3b0649ac261e3cf7c110acbdd74b13eeb3e9e6a91eb41832cb4d7d1f9049/jrnl-4.1.tar.gz"
  sha256 "980848f9c7ae8d4c844a4cae770c9686b5dda98f479dafac2c3cd72268a53f8b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d909ee76c42b86809ab3b0ab7e4d4cd0427cb0e6f349bd0b5c6479badd348b6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "933afe84cbaceb40988c652aeac36df5734ebb6de91adefa9d780255b48b055f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d001e4f20cb7024bbafb7e651782fa5953b86e9b36f282a9df86fb22c22571a"
    sha256 cellar: :any_skip_relocation, sonoma:         "18ff7ca781630bd43965a9fffa1d0e3e9e9db8a909f6ee901202f9771811679b"
    sha256 cellar: :any_skip_relocation, ventura:        "ebaf8b3ca0005dc85d21d04a3f413a445d4307ec62a2bc556a0f3a9f0c01451f"
    sha256 cellar: :any_skip_relocation, monterey:       "f47949e36afede7284bd4e80f242654faab56abcf3528ab950db3c2933f6d3c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ef4661e880b146444dec5a3005b0017704d055fc036b405b48a170dfd2cca18"
  end

  depends_on "cffi"
  depends_on "keyring"
  depends_on "pygments"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "expect" => :test

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/82/43/fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782c/ruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  def install
    virtualenv_install_with_resources

    # we depend on keyring, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.12")
    keyring = Formula["keyring"].opt_libexec
    (libexec/site_packages/"homebrew-keyring.pth").write keyring/site_packages
  end

  test do
    (testpath/"tests.sh").write <<~EOS
      #!/usr/bin/env expect

      set timeout 3
      match_max 100000

      spawn "#{bin}/jrnl" --encrypt
      expect -exact "Enter password for journal 'default': "
      sleep 0.5
      send -- "homebrew\\r"
      expect -exact "Enter password again: "
      sleep 0.5
      send -- "homebrew\\r"
      expect -exact "Do you want to store the password in your keychain? \\[Y/n\\] "
      send -- "n\\r"
      expect -re "Journal encrypted to .*"
      expect eof
    EOS

    # Write the journal
    input = "#{testpath}/journal.txt\nn\nn"
    assert_match "Journal 'default' created", pipe_output("#{bin}/jrnl My journal entry 2>&1", input, 0)
    assert_predicate testpath/"journal.txt", :exist?

    # Read the journal
    assert_match "#{testpath}/journal.txt", shell_output("#{bin}/jrnl --list 2>&1")

    # Encrypt the journal. Needs a TTY to read password.
    system "expect", "./tests.sh"
    assert_predicate testpath/".config/jrnl/jrnl.yaml", :exist?
    assert_match "encrypt: true", (testpath/".config/jrnl/jrnl.yaml").read
  end
end