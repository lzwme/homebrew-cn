require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.54.1.tgz"
  sha256 "e3eaf1f67a94feee1053954157c24214d7da7fd02b17daa46e44757ababed4f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ebd021ad7c9c5b2d393e7241d1c8b0ccf2e119901e1c40fa0df92e59bfee4b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ebd021ad7c9c5b2d393e7241d1c8b0ccf2e119901e1c40fa0df92e59bfee4b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ebd021ad7c9c5b2d393e7241d1c8b0ccf2e119901e1c40fa0df92e59bfee4b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "f920fcad1283bdc324af997a329b471442473dd9089c44431b8dd20a39a40d8f"
    sha256 cellar: :any_skip_relocation, ventura:        "f920fcad1283bdc324af997a329b471442473dd9089c44431b8dd20a39a40d8f"
    sha256 cellar: :any_skip_relocation, monterey:       "f920fcad1283bdc324af997a329b471442473dd9089c44431b8dd20a39a40d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ebd021ad7c9c5b2d393e7241d1c8b0ccf2e119901e1c40fa0df92e59bfee4b2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = "/dev/null"
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~EOS
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    EOS
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end