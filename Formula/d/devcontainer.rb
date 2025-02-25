class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.74.0.tgz"
  sha256 "d5c822c317cd011622cefe9b003c6a342db1693ae28d67022e408f8114e72d9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f0987344efc629f4311dfe3cf5c96130d9e718d222206cac640b554ed719238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f0987344efc629f4311dfe3cf5c96130d9e718d222206cac640b554ed719238"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f0987344efc629f4311dfe3cf5c96130d9e718d222206cac640b554ed719238"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d023ebd2d60b570de97605f756e417fd3ce7504851c969705fcd62d80fa7de1"
    sha256 cellar: :any_skip_relocation, ventura:       "2d023ebd2d60b570de97605f756e417fd3ce7504851c969705fcd62d80fa7de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f0987344efc629f4311dfe3cf5c96130d9e718d222206cac640b554ed719238"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    ENV["DOCKER_HOST"] = File::NULL
    # Modified .devcontainerdevcontainer.json from CLI example:
    # https:github.comdevcontainerscli#try-out-the-cli
    (testpath".devcontainer.json").write <<~JSON
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.comdevcontainersrust:0-1-bullseye"
      }
    JSON
    output = shell_output("#{bin}devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end