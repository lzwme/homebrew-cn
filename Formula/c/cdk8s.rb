class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.314.tgz"
  sha256 "3fa605f57310d615e79c927bd9ebc710a26f522018de0bfe29220be767265c55"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dcb312eaefb23375179580122416fe70abd0837660f1c94d75630eb1aa218c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dcb312eaefb23375179580122416fe70abd0837660f1c94d75630eb1aa218c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dcb312eaefb23375179580122416fe70abd0837660f1c94d75630eb1aa218c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e293c3b8ef9bb353baf62faeda344a82eb90be2aacdea38e4a7c13809a5fe25"
    sha256 cellar: :any_skip_relocation, ventura:       "3e293c3b8ef9bb353baf62faeda344a82eb90be2aacdea38e4a7c13809a5fe25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dcb312eaefb23375179580122416fe70abd0837660f1c94d75630eb1aa218c5"
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