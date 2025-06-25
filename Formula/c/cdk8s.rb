class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.110.tgz"
  sha256 "84fcb17555e5ebe2ea86d627b66daec84e18b9798362206e84b924085b210a93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75b158b229fc1d7b0980e5e9e5c1b991df2a453c123be2ec4a06b343e15f62b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75b158b229fc1d7b0980e5e9e5c1b991df2a453c123be2ec4a06b343e15f62b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75b158b229fc1d7b0980e5e9e5c1b991df2a453c123be2ec4a06b343e15f62b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8b213b1b839a8f61d6507655d401f1bdb3526e2679e64fd4336288564bbde48"
    sha256 cellar: :any_skip_relocation, ventura:       "e8b213b1b839a8f61d6507655d401f1bdb3526e2679e64fd4336288564bbde48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75b158b229fc1d7b0980e5e9e5c1b991df2a453c123be2ec4a06b343e15f62b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b158b229fc1d7b0980e5e9e5c1b991df2a453c123be2ec4a06b343e15f62b9"
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