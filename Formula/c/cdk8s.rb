class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.65.tgz"
  sha256 "5378b51d304240ef134a7ac7429e33d8e421c63fc32b6c59aaf146bb37819334"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9778b3f564877d8ccc0d0e796e468f5e6f798e04b7fa97326e07a8460e5da171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9778b3f564877d8ccc0d0e796e468f5e6f798e04b7fa97326e07a8460e5da171"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9778b3f564877d8ccc0d0e796e468f5e6f798e04b7fa97326e07a8460e5da171"
    sha256 cellar: :any_skip_relocation, sonoma:        "772b6a81abc6c83098a3ab7120f27f5381dea66d1d0090228b8d6e942b4379a2"
    sha256 cellar: :any_skip_relocation, ventura:       "772b6a81abc6c83098a3ab7120f27f5381dea66d1d0090228b8d6e942b4379a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9778b3f564877d8ccc0d0e796e468f5e6f798e04b7fa97326e07a8460e5da171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9778b3f564877d8ccc0d0e796e468f5e6f798e04b7fa97326e07a8460e5da171"
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