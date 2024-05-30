require "languagenode"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.61.0.tgz"
  sha256 "07b66d0c875ec6f25f97bdc2b7e3e85645ab093b7429ad9b20ba8eef3055ed60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee413c82f0901d0a40b564a458d2e555e2dc5a8ec01925716171ff0d22d7435e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee413c82f0901d0a40b564a458d2e555e2dc5a8ec01925716171ff0d22d7435e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee413c82f0901d0a40b564a458d2e555e2dc5a8ec01925716171ff0d22d7435e"
    sha256 cellar: :any_skip_relocation, sonoma:         "99606b6fc2c471c01e9b4bdd0e3b255de73fff891bc33d9e45567dab0597d327"
    sha256 cellar: :any_skip_relocation, ventura:        "99606b6fc2c471c01e9b4bdd0e3b255de73fff891bc33d9e45567dab0597d327"
    sha256 cellar: :any_skip_relocation, monterey:       "99606b6fc2c471c01e9b4bdd0e3b255de73fff891bc33d9e45567dab0597d327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08145beda5a773b29733f013b7e92d607928697d5d33b549e2fbb688570cc580"
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