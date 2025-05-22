class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.13.tgz"
  sha256 "242cf884f2d53a6ef3938833d66bb30234cfceb7c45ca9a5b7a965c145c36a10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8da6d8ce6ba9794cd9f5f9a5cedcee1c18c14c75e9c7929decb63cc28586d86b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8da6d8ce6ba9794cd9f5f9a5cedcee1c18c14c75e9c7929decb63cc28586d86b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8da6d8ce6ba9794cd9f5f9a5cedcee1c18c14c75e9c7929decb63cc28586d86b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bf74038b727d436d833f035d918f4276f2ca9dfd9cb877167af0899344d8ca1"
    sha256 cellar: :any_skip_relocation, ventura:       "3bf74038b727d436d833f035d918f4276f2ca9dfd9cb877167af0899344d8ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8da6d8ce6ba9794cd9f5f9a5cedcee1c18c14c75e9c7929decb63cc28586d86b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8da6d8ce6ba9794cd9f5f9a5cedcee1c18c14c75e9c7929decb63cc28586d86b"
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