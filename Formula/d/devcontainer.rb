require "languagenode"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https:containers.dev"
  url "https:registry.npmjs.org@devcontainerscli-cli-0.65.0.tgz"
  sha256 "0fad0a0cb19728cfb59315598e9baf0f085857e510bdc17593fa751bf6ff2c41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc8640c8f0bd94e4b2ec4593da8bc67ce76a8d84545562b3a191a2ce910a4e39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc8640c8f0bd94e4b2ec4593da8bc67ce76a8d84545562b3a191a2ce910a4e39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc8640c8f0bd94e4b2ec4593da8bc67ce76a8d84545562b3a191a2ce910a4e39"
    sha256 cellar: :any_skip_relocation, sonoma:         "15f3360277496179deba7e403e4310a884d9df662cc923273ec28df61d8f5c50"
    sha256 cellar: :any_skip_relocation, ventura:        "15f3360277496179deba7e403e4310a884d9df662cc923273ec28df61d8f5c50"
    sha256 cellar: :any_skip_relocation, monterey:       "15f3360277496179deba7e403e4310a884d9df662cc923273ec28df61d8f5c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4d8a6ef38d1cd903d9e946e7149733d0d1c965a65d6ba6faadfd8d0f7376356"
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