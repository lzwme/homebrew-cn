class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.11.tgz"
  sha256 "a4ea045fcecc07f2eb963627019982c964280994e39c43393f72713892ae48a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25de4fbf36ac9bc7c79f882d15104806856418bb51a2913106e6dacf542e486f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25de4fbf36ac9bc7c79f882d15104806856418bb51a2913106e6dacf542e486f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25de4fbf36ac9bc7c79f882d15104806856418bb51a2913106e6dacf542e486f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8054044964da66f845cf73c72d70163a1ed33497c772ce943390da0995d0237"
    sha256 cellar: :any_skip_relocation, ventura:       "d8054044964da66f845cf73c72d70163a1ed33497c772ce943390da0995d0237"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25de4fbf36ac9bc7c79f882d15104806856418bb51a2913106e6dacf542e486f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25de4fbf36ac9bc7c79f882d15104806856418bb51a2913106e6dacf542e486f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end