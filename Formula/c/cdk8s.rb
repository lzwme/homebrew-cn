class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.132.tgz"
  sha256 "15c9864f89aa2e19bc549cdce810c1385cc6456d9f8cead6c095bf2735361447"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f84f92f763d786e825ba817402a6865b4e12a5db12e1a6c4de722922c908d4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f84f92f763d786e825ba817402a6865b4e12a5db12e1a6c4de722922c908d4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f84f92f763d786e825ba817402a6865b4e12a5db12e1a6c4de722922c908d4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c58203c95752e3cdbea3e7f8dfbf73481fd7bdcac2516338eb2afb429b74cfba"
    sha256 cellar: :any_skip_relocation, ventura:       "c58203c95752e3cdbea3e7f8dfbf73481fd7bdcac2516338eb2afb429b74cfba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f84f92f763d786e825ba817402a6865b4e12a5db12e1a6c4de722922c908d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f84f92f763d786e825ba817402a6865b4e12a5db12e1a6c4de722922c908d4d"
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