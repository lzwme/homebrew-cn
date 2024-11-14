class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.262.tgz"
  sha256 "e323e6514d25c898f523ef732b7b42397953aec2f17df99f8c84a62fbb5786fd"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9e085a8bb0ccd7c1f74fb23015b8d23fa294610d6848803241d9c647d753d2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9e085a8bb0ccd7c1f74fb23015b8d23fa294610d6848803241d9c647d753d2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9e085a8bb0ccd7c1f74fb23015b8d23fa294610d6848803241d9c647d753d2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "684a3b78cd8ef5ca63646554aa71f37e94dc499287ddcbe62a6aaee153e00b88"
    sha256 cellar: :any_skip_relocation, ventura:       "684a3b78cd8ef5ca63646554aa71f37e94dc499287ddcbe62a6aaee153e00b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9e085a8bb0ccd7c1f74fb23015b8d23fa294610d6848803241d9c647d753d2e"
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