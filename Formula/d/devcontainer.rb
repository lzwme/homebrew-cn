require "languagenode"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.56.1.tgz"
  sha256 "51a4bce917eb0da72484df51b50601ceaf424750eb6340291e6d9882663d15cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be1102c6439235a35859e2a2d2acaf26619a7eff39c2a5aefe7101b41e2f3f05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be1102c6439235a35859e2a2d2acaf26619a7eff39c2a5aefe7101b41e2f3f05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be1102c6439235a35859e2a2d2acaf26619a7eff39c2a5aefe7101b41e2f3f05"
    sha256 cellar: :any_skip_relocation, sonoma:         "d716c488a0c82e18a4dac713f0ddb0a2a80434a6fa925297bb353d883c3050a8"
    sha256 cellar: :any_skip_relocation, ventura:        "d716c488a0c82e18a4dac713f0ddb0a2a80434a6fa925297bb353d883c3050a8"
    sha256 cellar: :any_skip_relocation, monterey:       "d716c488a0c82e18a4dac713f0ddb0a2a80434a6fa925297bb353d883c3050a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be1102c6439235a35859e2a2d2acaf26619a7eff39c2a5aefe7101b41e2f3f05"
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