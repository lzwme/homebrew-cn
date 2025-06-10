class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.95.tgz"
  sha256 "41d4b5fb88be61e10eb90fda3e6d570140edfe6eb892387482e32eae174ab6c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d5c502aedfd2c67dc1fb36fa242eda4bbe9b4ab969b3f8be3a38f2d324c3477"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d5c502aedfd2c67dc1fb36fa242eda4bbe9b4ab969b3f8be3a38f2d324c3477"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d5c502aedfd2c67dc1fb36fa242eda4bbe9b4ab969b3f8be3a38f2d324c3477"
    sha256 cellar: :any_skip_relocation, sonoma:        "f080f9ec79162dcbd15be7fb954d0985758ee6edbfabbf41260e9c1383122ed3"
    sha256 cellar: :any_skip_relocation, ventura:       "f080f9ec79162dcbd15be7fb954d0985758ee6edbfabbf41260e9c1383122ed3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d5c502aedfd2c67dc1fb36fa242eda4bbe9b4ab969b3f8be3a38f2d324c3477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d5c502aedfd2c67dc1fb36fa242eda4bbe9b4ab969b3f8be3a38f2d324c3477"
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