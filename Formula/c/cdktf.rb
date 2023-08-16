require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.17.3.tgz"
  sha256 "fd527a0047b783287413ed81a02f42cf57bee662cc7b9c9120d5a44794f5b031"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "d68ea510b2f4740dde20c68169678eedae18445dd7d9ba2539b4d05af2b9293e"
    sha256                               arm64_monterey: "165d47cd894afa38a3324050f1eb07fcaae58fdee98ca746ce37fb6fac034ab4"
    sha256                               arm64_big_sur:  "960facdb73c2c515478044608a3aa76cbc6d0fee83a7ea7dbfb6bd975072bc4b"
    sha256                               ventura:        "55c5d12303d7bc5dd5012e5ae1167134a9743894080fa7cbd048dbf65639efca"
    sha256                               monterey:       "4588b605a7f9e551e018cd8a1009498d6a00902d9ba74504c95fcd17ec3ec3fd"
    sha256                               big_sur:        "a135cbc22bda5e555719641ebfcf137bd31f30dd2bab34f87816e608c45c8b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "029255cd74e2e0064353e785aae55712c362026206b63566fd63fa7e45c8102d"
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