class Basti < Formula
  desc "Securely connect to RDS, Elasticache, and other AWS resources in VPCs"
  homepage "https:github.combasti-appbasti"
  url "https:registry.npmjs.orgbasti-basti-1.6.3.tgz"
  sha256 "78fd1d21c031405c38bedd24b3de6d132020fab9f14e22e31f4d21848dcf3378"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8af5517c229a3b3de009e413f222155cbc097ab03290f37caf8644ad0f35a55c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8af5517c229a3b3de009e413f222155cbc097ab03290f37caf8644ad0f35a55c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8af5517c229a3b3de009e413f222155cbc097ab03290f37caf8644ad0f35a55c"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb6bc1be4c182b694cd15fccdf52f9d292e465d8e0b249cc40ece01906d1a2aa"
    sha256 cellar: :any_skip_relocation, ventura:        "fb6bc1be4c182b694cd15fccdf52f9d292e465d8e0b249cc40ece01906d1a2aa"
    sha256 cellar: :any_skip_relocation, monterey:       "fb6bc1be4c182b694cd15fccdf52f9d292e465d8e0b249cc40ece01906d1a2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbcdc1b999d340c9c373b628c7234f8b48b03d3aaf43c2a6c622d85a6227a967"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binary, session-manager-plugin
    node_modules = libexec"libnode_modulesbastinode_modules"
    node_modules.glob("basti-session-manager-binary-**").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end

    generate_completions_from_executable(bin"basti", "completion",
                                            shells:                 [:bash, :zsh],
                                            shell_parameter_format: :none)
  end

  test do
    output = shell_output("#{bin}basti cleanup")
    assert_match "No Basti-managed resources found in your account", output

    assert_match version.to_s, shell_output("#{bin}basti --version")
  end
end