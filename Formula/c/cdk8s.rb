class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.175.tgz"
  sha256 "5197c186faab4d26982d3f318d95548b58d3a14086831deafc430b061737f07e"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37ab0cf70c4ca637755a34339937ace37c803181ecaeaa50d6553e3103786e1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37ab0cf70c4ca637755a34339937ace37c803181ecaeaa50d6553e3103786e1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37ab0cf70c4ca637755a34339937ace37c803181ecaeaa50d6553e3103786e1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1379e34b1d87dc11f681bd8dac0dc2ff06d28bb8a393edd771867ef409e2436f"
    sha256 cellar: :any_skip_relocation, ventura:        "1379e34b1d87dc11f681bd8dac0dc2ff06d28bb8a393edd771867ef409e2436f"
    sha256 cellar: :any_skip_relocation, monterey:       "1379e34b1d87dc11f681bd8dac0dc2ff06d28bb8a393edd771867ef409e2436f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d870a2fcaf9d95a7feb529f32c3a2dff379b72b81b722100a1aa10fbcca81cb6"
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