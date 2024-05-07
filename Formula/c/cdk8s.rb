require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.111.tgz"
  sha256 "41f3bfb32623592f5f65e98abe12ed1d6425af5bae6e8decdcf2a286f673ed14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "568ed4569da24644f21a29b86bfc0446c8d0d778803372a368903feba6edb60c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "568ed4569da24644f21a29b86bfc0446c8d0d778803372a368903feba6edb60c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "568ed4569da24644f21a29b86bfc0446c8d0d778803372a368903feba6edb60c"
    sha256 cellar: :any_skip_relocation, sonoma:         "39f680ffb7a27c29cbeeceb63523c026dc32013dea08bc495ec57235201eea32"
    sha256 cellar: :any_skip_relocation, ventura:        "39f680ffb7a27c29cbeeceb63523c026dc32013dea08bc495ec57235201eea32"
    sha256 cellar: :any_skip_relocation, monterey:       "39f680ffb7a27c29cbeeceb63523c026dc32013dea08bc495ec57235201eea32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "568ed4569da24644f21a29b86bfc0446c8d0d778803372a368903feba6edb60c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end