class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.294.tgz"
  sha256 "06cde2231cc58ca9ee36fe163681ace0ed33d6e94a4c2de855e048589fe44741"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "037d56ed637106173f11e7a06a1982eeffef29335274ed3056e27c5c311a83bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "037d56ed637106173f11e7a06a1982eeffef29335274ed3056e27c5c311a83bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "037d56ed637106173f11e7a06a1982eeffef29335274ed3056e27c5c311a83bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8ea3cf42ed5714ab090a7dc8e92c97807fb551a33c35e67f5ee132a3daf8e4d"
    sha256 cellar: :any_skip_relocation, ventura:       "c8ea3cf42ed5714ab090a7dc8e92c97807fb551a33c35e67f5ee132a3daf8e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "037d56ed637106173f11e7a06a1982eeffef29335274ed3056e27c5c311a83bc"
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