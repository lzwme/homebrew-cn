require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.16.2.tgz"
  sha256 "2fc1d1f3072737b394b8eeb8f0e1323ed90221b1af6d33ad171d7c2b8c84675f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f175d1c555ab49ce23d59e4102a702d323c201a46eb9cf1eae01abf867a59773"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f175d1c555ab49ce23d59e4102a702d323c201a46eb9cf1eae01abf867a59773"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f175d1c555ab49ce23d59e4102a702d323c201a46eb9cf1eae01abf867a59773"
    sha256 cellar: :any_skip_relocation, ventura:        "da4c4b1a25522cab2b94f1cfe4a59a9289f5ade64cf2374a8cc9319282338ef0"
    sha256 cellar: :any_skip_relocation, monterey:       "da4c4b1a25522cab2b94f1cfe4a59a9289f5ade64cf2374a8cc9319282338ef0"
    sha256 cellar: :any_skip_relocation, big_sur:        "da4c4b1a25522cab2b94f1cfe4a59a9289f5ade64cf2374a8cc9319282338ef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c343f26c9f97a33cdbc459e043f90bea5a3289d67e1ccefc1ff5f22430fd6abc"
  end

  depends_on "node@18"
  depends_on "terraform"

  def install
    node = Formula["node@18"]
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"cdktf").write_env_script "#{libexec}/bin/cdktf", { PATH: "#{node.opt_bin}:$PATH" }

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