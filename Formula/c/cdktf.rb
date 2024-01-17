require "languagenode"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https:github.comhashicorpterraform-cdk"
  url "https:registry.npmjs.orgcdktf-cli-cdktf-cli-0.20.1.tgz"
  sha256 "b2da63d6ac1715b3f62e540a2b46b7252f8d83720dccc581bd9204ed2e2466db"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "d334aed6392dd640283a0b77d4c4c469756f39841982bee96e9c466b697032e6"
    sha256                               arm64_ventura:  "91742c0db59c5397b825bacb9f4e346831d2fe6dc7f97199c976dc76b05cd338"
    sha256                               arm64_monterey: "66a1acab9526dd976de6989f4dc9be8a55be54d1a1e09e1762bb45090a4e8a15"
    sha256                               sonoma:         "13b5643323def7b0920b6adf252d27bcdb8905eccb2ad6a25877df69aa1cfade"
    sha256                               ventura:        "02b2d04362e3303bc2beb29c0f023a9e3c4febeb9d5cc251112f3b2407959a82"
    sha256                               monterey:       "89ffcd2b9192cb27da712b4a0323753952b2931ab0a641a64d1a46e3f06340d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c918f7cb074886f45424c0eded58c35630d3c3f67dfb86498d005eab04134513"
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