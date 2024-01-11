require "languagenode"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https:github.comhashicorpterraform-cdk"
  url "https:registry.npmjs.orgcdktf-cli-cdktf-cli-0.20.0.tgz"
  sha256 "bbb75fcc8bde5d60dcfe7959154a870b34381bb99957a2b74d3207bdbf3214eb"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "77f3a1f6499201629331bf57cb13da6c0570073b1772826f6b7686ffe968485c"
    sha256                               arm64_ventura:  "7edce83fb9ade0e85b33d0789189918c2d3e417536441576026a3d517845ecba"
    sha256                               arm64_monterey: "193723241207f0d9d025587b727ab06146d13b220d386b6d619861ca79fb802c"
    sha256                               sonoma:         "6d1e5ef8c6cbfa1dbe78b64eeb0a08a19ca349d509b541645b7800a71deae010"
    sha256                               ventura:        "1b083ee29d549f220d83d694fc1cc54d3996f23fae299bc28bc87f2205e2f642"
    sha256                               monterey:       "d6d547f80377ea809d683c848a80fd8d4c14c817ff9759bd9c2d260f2d14d374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce5fca3caed92610bf9eab5341872c7dcf1e6d72c23c8f11baaf7cb102e57e13"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modulescdktf-clinode_modules"
    node_pty_prebuilds = node_modules"@cdktfnode-pty-prebuilt-multiarchprebuilds"
    (node_pty_prebuilds"linux-x64").glob("node.abi*.musl.node").map(&:unlink)
    node_pty_prebuilds.each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    generate_completions_from_executable(libexec"bincdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}cdktf init --template='python' 2>&1", 1)
  end
end