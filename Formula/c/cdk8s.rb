class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.107.tgz"
  sha256 "016e84b06979d9aa778de87f00677d1dc5b529d528919cbce23d624af01bdb74"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44f993e3316757c441a387e7336c17e6ae7a6bfa94aac0bc71b524213b8894a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44f993e3316757c441a387e7336c17e6ae7a6bfa94aac0bc71b524213b8894a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44f993e3316757c441a387e7336c17e6ae7a6bfa94aac0bc71b524213b8894a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "df7efacc6543e70ffa186341598b10cce45b14fbbbcb2fcaf4057bb43a9e037d"
    sha256 cellar: :any_skip_relocation, ventura:       "df7efacc6543e70ffa186341598b10cce45b14fbbbcb2fcaf4057bb43a9e037d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f993e3316757c441a387e7336c17e6ae7a6bfa94aac0bc71b524213b8894a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f993e3316757c441a387e7336c17e6ae7a6bfa94aac0bc71b524213b8894a5"
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