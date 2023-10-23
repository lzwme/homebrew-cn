require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.19.0.tgz"
  sha256 "1e8cf857b5ef4ef2b737e8366a51a923013d231c38ff301d0a43c14f293c1b4d"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "c2b13603929ea3285828acd37c21a40c26ace189c79bb201a7f87c9940b8e230"
    sha256                               arm64_ventura:  "fc1e82ee42db919f8475a7b788e45c6a59a28f1fe50499b9467ccb885bddb8bc"
    sha256                               arm64_monterey: "e29089d4ad74b383e03f3a52ca9e27ba165ac2962fc5ea58f3d6bc48ab1ada33"
    sha256                               sonoma:         "311d7c2bf907f490b4187cd69d0cc962288adc34a44ccbafe933728c6145de4b"
    sha256                               ventura:        "670d37390d86dd5d10f9910cd840b60af91f386a41e66ff1cb048a8fc205a115"
    sha256                               monterey:       "e0bdf93dd2f962fe8a8781dedf994b6bb0c5f296aaca23fa1bd2ae1bc65a456c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63d8e8af6ced4674c25853f0f4974962a3b238c21d575ab3d24e10ae0fc0a837"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # remove non-native architecture pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/cdktf-cli/node_modules"
    node_pty_prebuilds = node_modules/"@cdktf/node-pty-prebuilt-multiarch/prebuilds"
    (node_pty_prebuilds/"linux-x64").glob("node.abi*.musl.node").map(&:unlink)
    node_pty_prebuilds.each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    generate_completions_from_executable(libexec/"bin/cdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end