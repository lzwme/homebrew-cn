require "languagenode"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.54.2.tgz"
  sha256 "ed12dd14da20fce2cfd6d9b4165d53e83c9086dff38e995275d90c65f2d4d4da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fb402c51f971923c967efdd55ad0c2fde4b7772d32a50e0eab0888a68786a80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fb402c51f971923c967efdd55ad0c2fde4b7772d32a50e0eab0888a68786a80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fb402c51f971923c967efdd55ad0c2fde4b7772d32a50e0eab0888a68786a80"
    sha256 cellar: :any_skip_relocation, sonoma:         "43f577e42b95783678b019274bd5f6f6962bc919077f34592ed78dd9796447df"
    sha256 cellar: :any_skip_relocation, ventura:        "43f577e42b95783678b019274bd5f6f6962bc919077f34592ed78dd9796447df"
    sha256 cellar: :any_skip_relocation, monterey:       "43f577e42b95783678b019274bd5f6f6962bc919077f34592ed78dd9796447df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb402c51f971923c967efdd55ad0c2fde4b7772d32a50e0eab0888a68786a80"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    ENV["DOCKER_HOST"] = "devnull"
    # Modified .devcontainerdevcontainer.json from CLI example:
    # https:github.comdevcontainerscli#try-out-the-cli
    (testpath".devcontainer.json").write <<~EOS
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.comdevcontainersrust:0-1-bullseye"
      }
    EOS
    output = shell_output("#{bin}devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end