class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.70.0.tgz"
  sha256 "80681888256c2cbe983d15fd918c6e9f3d7c28fa652a3e9f938b02e34a34cd23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0dc2f8b71b63fb06f15434c2a7fab2b981d0cc6778d4b837444498beb018906"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0dc2f8b71b63fb06f15434c2a7fab2b981d0cc6778d4b837444498beb018906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0dc2f8b71b63fb06f15434c2a7fab2b981d0cc6778d4b837444498beb018906"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d7ec85cfd7ad9839d145f5106b7cccdc5ba1130dfca2925712ba2c612210a3c"
    sha256 cellar: :any_skip_relocation, ventura:        "9d7ec85cfd7ad9839d145f5106b7cccdc5ba1130dfca2925712ba2c612210a3c"
    sha256 cellar: :any_skip_relocation, monterey:       "9d7ec85cfd7ad9839d145f5106b7cccdc5ba1130dfca2925712ba2c612210a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0dc2f8b71b63fb06f15434c2a7fab2b981d0cc6778d4b837444498beb018906"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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