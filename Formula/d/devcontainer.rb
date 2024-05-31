require "languagenode"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.62.0.tgz"
  sha256 "9b994cf4a530cfabcc158821921a6d73756511880f46595860a5623160c965a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7daeb3836a383b10eb753510679c8a1632af6c8f106721962c4b4b6cbdf6016b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7daeb3836a383b10eb753510679c8a1632af6c8f106721962c4b4b6cbdf6016b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7daeb3836a383b10eb753510679c8a1632af6c8f106721962c4b4b6cbdf6016b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9962b5b321cd6aaa7290beb94778bbef70fcbea7970de020ed6dbe01844035e"
    sha256 cellar: :any_skip_relocation, ventura:        "e9962b5b321cd6aaa7290beb94778bbef70fcbea7970de020ed6dbe01844035e"
    sha256 cellar: :any_skip_relocation, monterey:       "ce06db12292022f5521e0a786acc9daeac5680b855949e4275f1a9a3999d20e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4ae470de1d8cc0e2a14dce2696347c3911e1dab640ec88315f84196b3dac30"
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