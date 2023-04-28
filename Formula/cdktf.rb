require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.16.1.tgz"
  sha256 "515a125cfb7a7c8732c51c110bd7e1178ffc297221165d1b1124d7707465ca42"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8248e64fd477cc42e721764494d1d7020350a235e7b45ac81e9f130f2d4c5e7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8248e64fd477cc42e721764494d1d7020350a235e7b45ac81e9f130f2d4c5e7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8248e64fd477cc42e721764494d1d7020350a235e7b45ac81e9f130f2d4c5e7f"
    sha256 cellar: :any_skip_relocation, ventura:        "003a6266711a529ee76cc12d44dde12948ebf31172bcbe9787b3de0c511c7156"
    sha256 cellar: :any_skip_relocation, monterey:       "003a6266711a529ee76cc12d44dde12948ebf31172bcbe9787b3de0c511c7156"
    sha256 cellar: :any_skip_relocation, big_sur:        "003a6266711a529ee76cc12d44dde12948ebf31172bcbe9787b3de0c511c7156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6d854de17134a68c21ec24dfe4ff51237f52b2de0b054192118f6bb6f6fe3e4"
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