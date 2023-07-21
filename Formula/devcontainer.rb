require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.50.0.tgz"
  sha256 "392263a7ce4633caa0392d5b6ec2d87c978aafe058d7c07e5ec94c853ae9bad1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cfa2f9efaab718f51c01855804214cbc798aa92af693d380beeb2aece8e5651"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cfa2f9efaab718f51c01855804214cbc798aa92af693d380beeb2aece8e5651"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cfa2f9efaab718f51c01855804214cbc798aa92af693d380beeb2aece8e5651"
    sha256 cellar: :any_skip_relocation, ventura:        "294b2e77bb363398a377d63de308a562d76519aa37d26c20bb577c82c7103764"
    sha256 cellar: :any_skip_relocation, monterey:       "294b2e77bb363398a377d63de308a562d76519aa37d26c20bb577c82c7103764"
    sha256 cellar: :any_skip_relocation, big_sur:        "294b2e77bb363398a377d63de308a562d76519aa37d26c20bb577c82c7103764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "296864eb58b4271c3883402ab7958e611e57da4a0b63af73f0149ecacaf87649"
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