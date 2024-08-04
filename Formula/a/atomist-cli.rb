class AtomistCli < Formula
  desc "Unified command-line tool for interacting with Atomist services"
  homepage "https:github.comatomistcli"
  url "https:registry.npmjs.org@atomistcli-cli-1.8.0.tgz"
  sha256 "64bcc7484fa2f1b7172984c278ae928450149fb02b750f79454b1a6683d17f62"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "6f7f8b016f46718325419bda88b5b605070f6caa951007a1479d009490f2b25e"
    sha256                               arm64_ventura:  "91010cbaa3802b444bfcfb62569f4e953fcabf564da8cde87ab82b8c7b35fefa"
    sha256                               arm64_monterey: "2090a3d1b37500a44d836873fd4b3d8c8f0a6b094c61fb8530baa4b3f33ee82b"
    sha256                               sonoma:         "9f084e5811bda72cbdafaa9d6ef94475d4e62f8a02a9701482d48c77c2135cf3"
    sha256                               ventura:        "059bfc06ae2d8cd4ff0c588d543b6d79637c6e199b30544e832ca5fb472701ab"
    sha256                               monterey:       "35c62db45f98397cf306aad8b2f9e4a0b0f0b61f686da6b7b91c34d41bcf18d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8a420e052281702ab92e1b510422b86556e366f8c6b149fbae2ef3864466708"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
    bash_completion.install libexec"libnode_modules@atomistcliassetsbash_completionatomist"

    term_size_vendor_dir = libexec"libnode_modules@atomistclinode_modulesterm-sizevendor"
    rm_r(term_size_vendor_dir) # remove pre-built binaries

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