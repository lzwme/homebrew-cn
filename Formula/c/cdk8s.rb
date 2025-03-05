class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.7.tgz"
  sha256 "f38b87ab797033b4ac3564271892bc68a79d0bbdfe36415ef81dfe35e85e0b1f"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bdf286c704a51629989bb97f3820b9bdbd122ce2fa1de5db1bb4dc965f60bd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bdf286c704a51629989bb97f3820b9bdbd122ce2fa1de5db1bb4dc965f60bd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bdf286c704a51629989bb97f3820b9bdbd122ce2fa1de5db1bb4dc965f60bd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fe154bffa54de83b31699243dfa18de8ca79a77d1be4226d7d5bac9c5398068"
    sha256 cellar: :any_skip_relocation, ventura:       "6fe154bffa54de83b31699243dfa18de8ca79a77d1be4226d7d5bac9c5398068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bdf286c704a51629989bb97f3820b9bdbd122ce2fa1de5db1bb4dc965f60bd7"
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