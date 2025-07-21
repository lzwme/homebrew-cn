class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.136.tgz"
  sha256 "cd6f65a810d556c47ae0218186cfe525dee7837454d9a68827e54c05b7cee553"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2f626a149b46ca2f9c0c07e2cf9d8d247073673f21e83bf77d18c9f09a66885"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2f626a149b46ca2f9c0c07e2cf9d8d247073673f21e83bf77d18c9f09a66885"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2f626a149b46ca2f9c0c07e2cf9d8d247073673f21e83bf77d18c9f09a66885"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d75055de73a7c241e76c46622900a92ca3a54e18a4e582cb7b7e313136718f9"
    sha256 cellar: :any_skip_relocation, ventura:       "6d75055de73a7c241e76c46622900a92ca3a54e18a4e582cb7b7e313136718f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f626a149b46ca2f9c0c07e2cf9d8d247073673f21e83bf77d18c9f09a66885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2f626a149b46ca2f9c0c07e2cf9d8d247073673f21e83bf77d18c9f09a66885"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end