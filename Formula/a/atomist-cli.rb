require "languagenode"

class AtomistCli < Formula
  desc "Unified command-line tool for interacting with Atomist services"
  homepage "https:github.comatomistcli#readme"
  url "https:registry.npmjs.org@atomistcli-cli-1.8.0.tgz"
  sha256 "64bcc7484fa2f1b7172984c278ae928450149fb02b750f79454b1a6683d17f62"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "0570b71a9d42a8ddb764ddb444e5893476d834890cb0409d2c7517d7c42acc9c"
    sha256                               arm64_ventura:  "18a7ce7b98c8df09e82ba610dfb8dbd0a701eb79fd1f2f875ccd559e7bd52613"
    sha256                               arm64_monterey: "19edfaf9952cadd88d48f7d2e2a195c999c37e6eb4c1531b415d69889f3ce23a"
    sha256                               arm64_big_sur:  "937a87c1bcde6def60a36a358636f550d6328ec2dcdda13002ba1f8ef3989943"
    sha256                               sonoma:         "6f7c5dafd72b98927605fc0b574ff07038ac1fbcbd256c06e78a066f9536199e"
    sha256                               ventura:        "7736c33a1b3b601a0ccc74c2bf9ffba4219b4ac736b8cad67d84631f04b11e58"
    sha256                               monterey:       "ea04ea67623c76cc8362ae0e72c60d406e48fe840bcfa66e5d752cc65a0c18aa"
    sha256                               big_sur:        "99d4af26e3123803de4a2511d721f3ed2765afebe12097682be23c73a6d94cf8"
    sha256                               catalina:       "6c8e97645aa96025533c4ebf3549bc805b7a7f7b3370560280997ff367306c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78f7f291b352c3dcefae8c8e1f578a19ed7dacb411193702e2b29b3aaafd081e"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink libexec.glob("bin*")
    bash_completion.install libexec"libnode_modules@atomistcliassetsbash_completionatomist"

    term_size_vendor_dir = libexec"libnode_modules@atomistclinode_modulesterm-sizevendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin"term-size").relative_path_from(macos_dir), macos_dir
    end

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    assert_predicate bin"atomist", :exist?
    assert_predicate bin"atomist", :executable?
    assert_predicate bin"@atomist", :exist?
    assert_predicate bin"@atomist", :executable?

    run_output = shell_output("#{bin}atomist 2>&1", 1)
    assert_match "Not enough non-option arguments", run_output
    assert_match "Specify --help for available options", run_output

    version_output = shell_output("#{bin}atomist --version")
    assert_match "@atomistcli", version_output
    assert_match "@atomistsdm ", version_output
    assert_match "@atomistsdm-core", version_output
    assert_match "@atomistsdm-local", version_output

    skill_output = shell_output("#{bin}atomist show skills")
    assert_match(\d+ commands are available from \d+ connected SDMs, skill_output)
  end
end