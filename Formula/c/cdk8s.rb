class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.50.tgz"
  sha256 "b7f88e3e9fe00ef2c89869ccf100d8dd966dad1310490f5c44a1d034b23101f4"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cafc43f023460725b6f72f9098ba50ff9d0bda4a372ff6678414cdf9dc77d75e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cafc43f023460725b6f72f9098ba50ff9d0bda4a372ff6678414cdf9dc77d75e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cafc43f023460725b6f72f9098ba50ff9d0bda4a372ff6678414cdf9dc77d75e"
    sha256 cellar: :any_skip_relocation, sonoma:        "db92a5ea31a28311996ad02fea8972729b0630125f8b588e7490f4b2813328b7"
    sha256 cellar: :any_skip_relocation, ventura:       "db92a5ea31a28311996ad02fea8972729b0630125f8b588e7490f4b2813328b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cafc43f023460725b6f72f9098ba50ff9d0bda4a372ff6678414cdf9dc77d75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cafc43f023460725b6f72f9098ba50ff9d0bda4a372ff6678414cdf9dc77d75e"
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