class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.331.tgz"
  sha256 "f35146acc9c69a2f46c6a46241f1bb8aea3652cb8597dd26b6397bbf8eb5acc5"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ceac40c3b664ddda08bd9f4ff10aac01e79f027ccf9c363f2b27c096aa8316f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ceac40c3b664ddda08bd9f4ff10aac01e79f027ccf9c363f2b27c096aa8316f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ceac40c3b664ddda08bd9f4ff10aac01e79f027ccf9c363f2b27c096aa8316f"
    sha256 cellar: :any_skip_relocation, sonoma:        "74cb4579be3e4db64d96ec0f461d6a602b729a3f69c3056ef6b61dfa142c43d1"
    sha256 cellar: :any_skip_relocation, ventura:       "74cb4579be3e4db64d96ec0f461d6a602b729a3f69c3056ef6b61dfa142c43d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ceac40c3b664ddda08bd9f4ff10aac01e79f027ccf9c363f2b27c096aa8316f"
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