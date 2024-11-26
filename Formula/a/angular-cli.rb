class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.0.2.tgz"
  sha256 "46784eb87510495fdece050589d6e153a84b0f721a8a3ab027759fdd220f52b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c548819d58b261995e92a0e1df1083ed6b2921b3e205931952bb35da84f0c1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c548819d58b261995e92a0e1df1083ed6b2921b3e205931952bb35da84f0c1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c548819d58b261995e92a0e1df1083ed6b2921b3e205931952bb35da84f0c1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "59201a926a067ad63098252a704df80792094591a54fe1e3e92a0ad12557c515"
    sha256 cellar: :any_skip_relocation, ventura:       "59201a926a067ad63098252a704df80792094591a54fe1e3e92a0ad12557c515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c548819d58b261995e92a0e1df1083ed6b2921b3e205931952bb35da84f0c1d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end