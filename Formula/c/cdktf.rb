require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.18.1.tgz"
  sha256 "fbbb1eb05160bb5b475d5c3938af775e8ec1b6eec171843c18461f0ef112646d"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "c63f5a1ec76b6b33f41edcb5d91693a3e0120a7cad206eaf13bc13be4eb432b1"
    sha256                               arm64_ventura:  "6415d99175f9e72f7343a665ffd54f218f314ba7732ef2aeb97c956bccf26427"
    sha256                               arm64_monterey: "990a7b242711e5f77c269aadd9e844f80c8bc94af4103231a93520ae814ff414"
    sha256                               sonoma:         "fc872b9de9555fba0fefd213d00df680381587cb0984e141450c9ccf1c5a935a"
    sha256                               ventura:        "24741c5f4da5f7afea5807518e7b53a3dcce9f395de5dc03183232b908e7d9ec"
    sha256                               monterey:       "cb5231f34733d542f07dc799089a45f892abcdf2acb780bc195340e89d74a6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c59727cdfb418a63b619e6120e1a2f081d73f8e789766325e79fc1c624bd0b1"
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