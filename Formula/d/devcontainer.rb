class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.78.0.tgz"
  sha256 "db82d07b9f4fcef30377e05c5f652344bdf8b122343ceb643ff921b0323835c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ded9b65a2b474480a59960830a78d165cdd208f24eb66186ad5c4cfa7c0a406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ded9b65a2b474480a59960830a78d165cdd208f24eb66186ad5c4cfa7c0a406"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ded9b65a2b474480a59960830a78d165cdd208f24eb66186ad5c4cfa7c0a406"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7bfd2ac6a86989aae43ec5126f2acbf7e2a74ff84d92efad3a378c2ed6143fd"
    sha256 cellar: :any_skip_relocation, ventura:       "f7bfd2ac6a86989aae43ec5126f2acbf7e2a74ff84d92efad3a378c2ed6143fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ded9b65a2b474480a59960830a78d165cdd208f24eb66186ad5c4cfa7c0a406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ded9b65a2b474480a59960830a78d165cdd208f24eb66186ad5c4cfa7c0a406"
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