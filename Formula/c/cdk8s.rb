class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.55.tgz"
  sha256 "c3e7cdffc5c1111991dda73665a5629895df379cccb066f198a9e83e3443eac8"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6df286f674fbd114405b624fe73d22768151482d43df5c835db81b5095f87b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6df286f674fbd114405b624fe73d22768151482d43df5c835db81b5095f87b9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6df286f674fbd114405b624fe73d22768151482d43df5c835db81b5095f87b9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e958028e36102e9cfb380f32c9452cc33653993b804462d62e636d30690d04f"
    sha256 cellar: :any_skip_relocation, ventura:       "2e958028e36102e9cfb380f32c9452cc33653993b804462d62e636d30690d04f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6df286f674fbd114405b624fe73d22768151482d43df5c835db81b5095f87b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6df286f674fbd114405b624fe73d22768151482d43df5c835db81b5095f87b9d"
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