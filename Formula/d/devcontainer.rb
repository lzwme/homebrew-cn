require "languagenode"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.67.0.tgz"
  sha256 "b789259911754b7c86458c8ed3404023bd32f56b6c307d21473b11dde4511fad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ac30f4ad3d3e6c42c39794769d9cb9df8e7a8c74e47da6741c111f241291e69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ac30f4ad3d3e6c42c39794769d9cb9df8e7a8c74e47da6741c111f241291e69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ac30f4ad3d3e6c42c39794769d9cb9df8e7a8c74e47da6741c111f241291e69"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1b9d63ca859075e8985fe6dbf7c4a9391f150c00f31b60c8b81af364f18a54d"
    sha256 cellar: :any_skip_relocation, ventura:        "c1b9d63ca859075e8985fe6dbf7c4a9391f150c00f31b60c8b81af364f18a54d"
    sha256 cellar: :any_skip_relocation, monterey:       "c1b9d63ca859075e8985fe6dbf7c4a9391f150c00f31b60c8b81af364f18a54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "682fff607070af8378a119bce31354eb909cccaa3b9607bf5afb3e544c64f278"
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