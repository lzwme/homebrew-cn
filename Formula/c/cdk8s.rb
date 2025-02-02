class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.311.tgz"
  sha256 "374d9517dbe9576ac879d97a4344207dfbf0fdb9819cfa841c11f435ffe48073"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18c12f3bc88c840cc04d7173568af6047f6be618f9003bee3578898b12b0bc0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18c12f3bc88c840cc04d7173568af6047f6be618f9003bee3578898b12b0bc0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18c12f3bc88c840cc04d7173568af6047f6be618f9003bee3578898b12b0bc0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec3dc9acbb698843bb6172330b8b8d7a1057885d4bedb5ff18846f4f46866476"
    sha256 cellar: :any_skip_relocation, ventura:       "ec3dc9acbb698843bb6172330b8b8d7a1057885d4bedb5ff18846f4f46866476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18c12f3bc88c840cc04d7173568af6047f6be618f9003bee3578898b12b0bc0c"
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