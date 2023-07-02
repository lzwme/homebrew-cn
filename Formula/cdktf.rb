require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.17.0.tgz"
  sha256 "6c061873661a7da3727dceb3403895ddfca897deb855b189b7be363d10d0d691"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "42428d858621cf17430e33fc89372fd24224ab71ba920284bc3f5a2214839e35"
    sha256                               arm64_monterey: "5ffbae837b60b33ddbd0e86c8b318c017603da418e3316f7b4d4dcfec3858ae8"
    sha256                               arm64_big_sur:  "d4e200913991919f3680b7299d1d0b5cedf2b3037caa8449958d47d520fe27dd"
    sha256                               ventura:        "b0588e4c753a4a78f8b21fbfb814f9b24df5fcf63f65751d0e3bcbb8346897f0"
    sha256                               monterey:       "d14228a26bd5417088fa2c6537bd9f19b552290bcfc89c110d272f167a37009e"
    sha256                               big_sur:        "6ef7251b906d127079dd70986a6bcbc6d328de2e1ff2e493e33db6b8f75915fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4dc4f3d81cf46647a8687e1ac44b5f61730b013fcebced681149fb95fe1aed"
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