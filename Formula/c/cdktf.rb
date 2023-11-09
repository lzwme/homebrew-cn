require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.19.1.tgz"
  sha256 "8a386e5b79c506e5db82ef7609072cfca1743c60be5300370bb0e7e5d0d04a36"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "22c055bd09170fadcab28dc955d00c2c5907fbf5d8a2c2065c2d1642a3293e82"
    sha256                               arm64_ventura:  "01aec9f54111211b0b6a0184df572c72e5dfc3564dacdc25e9129b6aaeb77cb9"
    sha256                               arm64_monterey: "6745be585003d8dd9f6c066bbde182db57c1d16c7a7866eeb7b4e72f9bc1bf83"
    sha256                               sonoma:         "cd6f3046ed8c8466158ebab52e0089bd702ac6ca819f611634f8be1facdde208"
    sha256                               ventura:        "2c809780d629fb81ebc688b2e0e139d0aec63819941460bd26c43e0e777001d9"
    sha256                               monterey:       "d5216d1f0031277df70ca8aa61c617220d4cc578a25642e4b00eb6177aea8b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e22fcaefd4f00aab5ab40e1734bd88fcfdcd1df712ce2a5151b54ade1754b816"
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