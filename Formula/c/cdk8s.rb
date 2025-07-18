class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.133.tgz"
  sha256 "c2e1143e0f3a6ac9ea98b1fd101c04da09393baaaef930f15c12bfa5aec9a78a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd12fb0db64ab92fa7714bf53f479436f0d1ec5a8dc546c086a70dbe8f4c0d71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd12fb0db64ab92fa7714bf53f479436f0d1ec5a8dc546c086a70dbe8f4c0d71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd12fb0db64ab92fa7714bf53f479436f0d1ec5a8dc546c086a70dbe8f4c0d71"
    sha256 cellar: :any_skip_relocation, sonoma:        "80f851b5e6767efbfaeb2190578eb11a599a0808fb92222605dc54d98bcf51fd"
    sha256 cellar: :any_skip_relocation, ventura:       "80f851b5e6767efbfaeb2190578eb11a599a0808fb92222605dc54d98bcf51fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd12fb0db64ab92fa7714bf53f479436f0d1ec5a8dc546c086a70dbe8f4c0d71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd12fb0db64ab92fa7714bf53f479436f0d1ec5a8dc546c086a70dbe8f4c0d71"
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