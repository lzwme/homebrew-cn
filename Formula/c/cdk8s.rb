class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.47.tgz"
  sha256 "e3ff00de8a0306211fe7c61c5757f17a76a8aa560c622adff5ae3012562187bf"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b0ff74f147762da99742cb45bff28a07ed4bc2b3424d4535d51f444684fb680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b0ff74f147762da99742cb45bff28a07ed4bc2b3424d4535d51f444684fb680"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b0ff74f147762da99742cb45bff28a07ed4bc2b3424d4535d51f444684fb680"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cf31a234f2ff737d8f132cc7488772ee953dc7e6158c171715de855a8f283f1"
    sha256 cellar: :any_skip_relocation, ventura:       "7cf31a234f2ff737d8f132cc7488772ee953dc7e6158c171715de855a8f283f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b0ff74f147762da99742cb45bff28a07ed4bc2b3424d4535d51f444684fb680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0ff74f147762da99742cb45bff28a07ed4bc2b3424d4535d51f444684fb680"
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