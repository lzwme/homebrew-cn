require "languagenode"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https:github.comhashicorpterraform-cdk"
  url "https:registry.npmjs.orgcdktf-cli-cdktf-cli-0.20.2.tgz"
  sha256 "0d96ffae94f92018bb172adbeec53ed417227a5e77bf0a603a8f129728bf5c75"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "8dc2cd300eebbe034363be2301bf7fe9652048b7fb1ed94a51ae8a918359e246"
    sha256                               arm64_ventura:  "c5d3055f90cd23e9cc5c56a75cfb7a870219ff01d4065b9713edd22736741fd9"
    sha256                               arm64_monterey: "309d2c0cd928d1917f4454616793f4d022695b5bd1d74d131325199d826425ff"
    sha256                               sonoma:         "c5016f36ad332856b64aefd8d40c4341198bc59e5751313e0ea1f3f9de60177e"
    sha256                               ventura:        "daf7a56e6770cc1cd1c7d9e3850b5b91f6c56b40efbf17f389ec1de707b7951f"
    sha256                               monterey:       "03fe4599c8d0ff4ce8d0204a6138949d037f934845ffe2aee5593d1ca995ac12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c95f5c373b23a25c0b42594cffc2f02cac9448a8a065c783e293895460186451"
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