class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.134.tgz"
  sha256 "9b080b06879fe9b38d56bff9e0ebd97d1951c6c8089e366b63838c3a837f3fd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8476854f923087f885b58db5d7d6e7b4f2e5e81b21938c77d981950ac7cc64fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8476854f923087f885b58db5d7d6e7b4f2e5e81b21938c77d981950ac7cc64fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8476854f923087f885b58db5d7d6e7b4f2e5e81b21938c77d981950ac7cc64fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8819763fbf5665ebb07d2485afe0a442cf097e8d4bd1fb18eaaff292ae9cb99"
    sha256 cellar: :any_skip_relocation, ventura:       "e8819763fbf5665ebb07d2485afe0a442cf097e8d4bd1fb18eaaff292ae9cb99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8476854f923087f885b58db5d7d6e7b4f2e5e81b21938c77d981950ac7cc64fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8476854f923087f885b58db5d7d6e7b4f2e5e81b21938c77d981950ac7cc64fe"
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