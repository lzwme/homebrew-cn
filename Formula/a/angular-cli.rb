class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.0.1.tgz"
  sha256 "41665e3e3b4e0c5098222901a2ff4ee6a86f5c38d6a91e1bab63f239a185d776"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0f38c014199f4af0f2f5095831534b447a7df4f83b4027b4bbe50b9989a992f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0f38c014199f4af0f2f5095831534b447a7df4f83b4027b4bbe50b9989a992f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0f38c014199f4af0f2f5095831534b447a7df4f83b4027b4bbe50b9989a992f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab382544be13efafef6510d3d3a817759b1ef0117ce451f04d82c9751de10414"
    sha256 cellar: :any_skip_relocation, ventura:       "ab382544be13efafef6510d3d3a817759b1ef0117ce451f04d82c9751de10414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0f38c014199f4af0f2f5095831534b447a7df4f83b4027b4bbe50b9989a992f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0f38c014199f4af0f2f5095831534b447a7df4f83b4027b4bbe50b9989a992f"
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