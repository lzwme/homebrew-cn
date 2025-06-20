class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.105.tgz"
  sha256 "98fdba0682761b4bc3d09882f46b359e605acd096b1262c5600b6825f7f9b8c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02f7e31bfad0228e7768cad262c7d14d550dfc37fdf77fce7c469aab1e1a8e27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02f7e31bfad0228e7768cad262c7d14d550dfc37fdf77fce7c469aab1e1a8e27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02f7e31bfad0228e7768cad262c7d14d550dfc37fdf77fce7c469aab1e1a8e27"
    sha256 cellar: :any_skip_relocation, sonoma:        "2348c872f6c30b95d14ed61ad00581a8ed30e037374f60d304afa8e9f0c7c64e"
    sha256 cellar: :any_skip_relocation, ventura:       "2348c872f6c30b95d14ed61ad00581a8ed30e037374f60d304afa8e9f0c7c64e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02f7e31bfad0228e7768cad262c7d14d550dfc37fdf77fce7c469aab1e1a8e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02f7e31bfad0228e7768cad262c7d14d550dfc37fdf77fce7c469aab1e1a8e27"
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