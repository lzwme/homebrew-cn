class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.79.0.tgz"
  sha256 "8b4b78b0cfe82da5e041b93ac12982796df2a10064c3a685f369cca33f32af5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daca9b9b284686e250a522850cb827786d23a5a794810fbca832e888f2974e64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daca9b9b284686e250a522850cb827786d23a5a794810fbca832e888f2974e64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daca9b9b284686e250a522850cb827786d23a5a794810fbca832e888f2974e64"
    sha256 cellar: :any_skip_relocation, sonoma:        "89d218cb92a24116969f12e71f4aa86fbf84360fb9eb94dd2778ed5a12c7b5b8"
    sha256 cellar: :any_skip_relocation, ventura:       "89d218cb92a24116969f12e71f4aa86fbf84360fb9eb94dd2778ed5a12c7b5b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daca9b9b284686e250a522850cb827786d23a5a794810fbca832e888f2974e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daca9b9b284686e250a522850cb827786d23a5a794810fbca832e888f2974e64"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = File::NULL
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~JSON
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    JSON
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end