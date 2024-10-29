class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.254.tgz"
  sha256 "f2e551c8c55cb67d73e7764fc6ba614ef3accb04c78c06b593e9304659d41328"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fd65395259951fbce9e548bf0c276d515574355043f46645273f1392390af77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fd65395259951fbce9e548bf0c276d515574355043f46645273f1392390af77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fd65395259951fbce9e548bf0c276d515574355043f46645273f1392390af77"
    sha256 cellar: :any_skip_relocation, sonoma:        "df9c025ec44679bde557e12f1c173041a17d8eef0570d2eb89ad82a0b7f56279"
    sha256 cellar: :any_skip_relocation, ventura:       "df9c025ec44679bde557e12f1c173041a17d8eef0570d2eb89ad82a0b7f56279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd65395259951fbce9e548bf0c276d515574355043f46645273f1392390af77"
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