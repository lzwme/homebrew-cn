require "languagenode"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.56.0.tgz"
  sha256 "f27fc41a868e81829c9b97d6d535df5e2989b784aa2712e2e17be4d73148a30d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbeabdffde21b81a86518d54ffb19609e80e3a5dd55464ce3b8accdae2232187"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbeabdffde21b81a86518d54ffb19609e80e3a5dd55464ce3b8accdae2232187"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbeabdffde21b81a86518d54ffb19609e80e3a5dd55464ce3b8accdae2232187"
    sha256 cellar: :any_skip_relocation, sonoma:         "b78057bd3499c263159982f2de2416e7a0c659cbc094082690ea56560c760daf"
    sha256 cellar: :any_skip_relocation, ventura:        "b78057bd3499c263159982f2de2416e7a0c659cbc094082690ea56560c760daf"
    sha256 cellar: :any_skip_relocation, monterey:       "b78057bd3499c263159982f2de2416e7a0c659cbc094082690ea56560c760daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbeabdffde21b81a86518d54ffb19609e80e3a5dd55464ce3b8accdae2232187"
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