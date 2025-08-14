class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.153.tgz"
  sha256 "2d44da3e02f67715302dff1816dba8c74893453dbac3e8ee404f95258580ed49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f170b6b1f77b523d1f7ed655255bd079a6046a2cde8bb24ffd519c38796c43ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f170b6b1f77b523d1f7ed655255bd079a6046a2cde8bb24ffd519c38796c43ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f170b6b1f77b523d1f7ed655255bd079a6046a2cde8bb24ffd519c38796c43ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "db6bc5766042ad76d841ddd64b8d664c1e976c9d54f12695092d9fb4a433c2b5"
    sha256 cellar: :any_skip_relocation, ventura:       "db6bc5766042ad76d841ddd64b8d664c1e976c9d54f12695092d9fb4a433c2b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f170b6b1f77b523d1f7ed655255bd079a6046a2cde8bb24ffd519c38796c43ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f170b6b1f77b523d1f7ed655255bd079a6046a2cde8bb24ffd519c38796c43ec"
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