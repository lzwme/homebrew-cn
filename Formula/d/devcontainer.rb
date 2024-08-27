class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.69.0.tgz"
  sha256 "fa20a4a95bd9ca7143187d7958a47f0a087a78e4e89d0c592a9cf78fa363a91e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98aa876cafa71d6ff1e8e7cda62dc425fdd81a0919a20470f8b6a64841143e5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98aa876cafa71d6ff1e8e7cda62dc425fdd81a0919a20470f8b6a64841143e5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98aa876cafa71d6ff1e8e7cda62dc425fdd81a0919a20470f8b6a64841143e5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "517f405d3603adce917e91b1cc37fa12b143abf99a635cb18243e808c42b0d34"
    sha256 cellar: :any_skip_relocation, ventura:        "517f405d3603adce917e91b1cc37fa12b143abf99a635cb18243e808c42b0d34"
    sha256 cellar: :any_skip_relocation, monterey:       "517f405d3603adce917e91b1cc37fa12b143abf99a635cb18243e808c42b0d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98aa876cafa71d6ff1e8e7cda62dc425fdd81a0919a20470f8b6a64841143e5e"
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