require "languagenode"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.66.0.tgz"
  sha256 "d5b4789e8d40625e8922f8801811b4c8cd922d38b5c03cb9f915c9d878b69b67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95f160a94d725bf41d015b01fa052b6bafc66c76c6f474079403b882bf7ae3e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95f160a94d725bf41d015b01fa052b6bafc66c76c6f474079403b882bf7ae3e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95f160a94d725bf41d015b01fa052b6bafc66c76c6f474079403b882bf7ae3e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "62689e13deef0bfdb47abd1370108f35bbb131504254b8335bd4e2a73a712255"
    sha256 cellar: :any_skip_relocation, ventura:        "62689e13deef0bfdb47abd1370108f35bbb131504254b8335bd4e2a73a712255"
    sha256 cellar: :any_skip_relocation, monterey:       "62689e13deef0bfdb47abd1370108f35bbb131504254b8335bd4e2a73a712255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cba246a1d9a60aa9b3fef05ea473100d2d38b9ea89345c14056f6ef54f9617eb"
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