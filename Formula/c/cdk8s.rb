class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.4.tgz"
  sha256 "d8794aaaf72bca75f99ab6157b48927d9094d7b5be0c66bb9b8b737526033405"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4613848171aa23cb54d4164bda72032226a06769d89f7652fee36b83673f02a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4613848171aa23cb54d4164bda72032226a06769d89f7652fee36b83673f02a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4613848171aa23cb54d4164bda72032226a06769d89f7652fee36b83673f02a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b396837b153eeccbac23b5db61ad8acd32ecfff50b1722c51af324f8028d8185"
    sha256 cellar: :any_skip_relocation, ventura:       "b396837b153eeccbac23b5db61ad8acd32ecfff50b1722c51af324f8028d8185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4613848171aa23cb54d4164bda72032226a06769d89f7652fee36b83673f02a1"
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