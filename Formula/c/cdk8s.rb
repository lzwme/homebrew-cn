class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.321.tgz"
  sha256 "8bc830b3dc44d38a76ed8a102be309933450131a5cc14737ea9727f799d6467a"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bcb131ae0d744c780a5dd0b8ce31e4e8d034dfbfc929cce522c21a2e542ec70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bcb131ae0d744c780a5dd0b8ce31e4e8d034dfbfc929cce522c21a2e542ec70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bcb131ae0d744c780a5dd0b8ce31e4e8d034dfbfc929cce522c21a2e542ec70"
    sha256 cellar: :any_skip_relocation, sonoma:        "c00c7019a36b7f48300309519f50c47effee43228801501a293f041b46e80ef3"
    sha256 cellar: :any_skip_relocation, ventura:       "c00c7019a36b7f48300309519f50c47effee43228801501a293f041b46e80ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bcb131ae0d744c780a5dd0b8ce31e4e8d034dfbfc929cce522c21a2e542ec70"
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