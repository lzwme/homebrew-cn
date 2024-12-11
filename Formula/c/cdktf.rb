class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https:github.comhashicorpterraform-cdk"
  url "https:registry.npmjs.orgcdktf-cli-cdktf-cli-0.20.10.tgz"
  sha256 "2ee1c87374d435b1fa649d2f0d5131adf28d14c4d8bd1c29004ea16e4a9e9f40"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sequoia: "4aa6a8cb4fb6e32664ed6cc3dad95132786c8a8739991a7286c66b6f80be4749"
    sha256                               arm64_sonoma:  "3f64f620e6a2cf797f259e6c51edb9c06a3b57aa9ade23cba4d84cf850b111e0"
    sha256                               arm64_ventura: "f97805ce21d9ee697081078e212bd880c319fe81ba530e1aa7208d3b566d040a"
    sha256                               sonoma:        "cf6f498eb9c7164d696886f42606f10e67d95a97e6c3021ecd6a060086ebbc0d"
    sha256                               ventura:       "1b5ead114d0513ed8f97fdd858f06322331aa5dd3a407e6f1daf574524ad3b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44b00d34cd932fb66bad4803608d785f5935ec6c40358354686c4164b21eef42"
  end

  depends_on "opentofu" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modulescdktf-clinode_modules"
    node_pty_prebuilds = node_modules"@cdktfnode-pty-prebuilt-multiarchprebuilds"
    (node_pty_prebuilds"linux-x64").glob("node.abi*.musl.node").map(&:unlink)
    node_pty_prebuilds.each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    generate_completions_from_executable(libexec"bincdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    ENV["TERRAFORM_BINARY_NAME"] = "tofu"

    touch "unwanted-file"
    output = shell_output("#{bin}cdktf init --template='python' 2>&1", 1)
    assert_match "ERROR: Cannot initialize a project in a non-empty directory", output
  end
end