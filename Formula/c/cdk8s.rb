class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.261.tgz"
  sha256 "16416327e6fe1ddc41b2599f36428e17f6cae0a45e61bcb73f16d89db655a69e"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22e655abe16077204d2b3e09edcb4617a4c14efe00964dd9cd964a7f42f33ad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22e655abe16077204d2b3e09edcb4617a4c14efe00964dd9cd964a7f42f33ad1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22e655abe16077204d2b3e09edcb4617a4c14efe00964dd9cd964a7f42f33ad1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1214d67eb9937d930ec9b0514c60ba2abf7a86a689e1b59900b40b8f59e11f7e"
    sha256 cellar: :any_skip_relocation, ventura:       "1214d67eb9937d930ec9b0514c60ba2abf7a86a689e1b59900b40b8f59e11f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e655abe16077204d2b3e09edcb4617a4c14efe00964dd9cd964a7f42f33ad1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end