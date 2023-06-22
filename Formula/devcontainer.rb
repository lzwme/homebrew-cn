require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.45.0.tgz"
  sha256 "490f025b0ea5ff567870552f67e19a7342cf214dd5e884ede39d59006df98065"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "10f9bc7d410e847217b79e0d2edbe3ba2a44a13b421e041c7d22f95305f06761"
    sha256                               arm64_monterey: "f0651fbc90135378f18f3701c0f0f0d26395cc4710ed15374028f0a8b1f26889"
    sha256                               arm64_big_sur:  "5d5cd08190abd5b0713ae856ea4d4b700108c7cd3a53b6aae96d0266d583c759"
    sha256                               ventura:        "196d5e4a58426eb0cbef580c5b86e4324537d5e7267da219675ce6a17ef2be48"
    sha256                               monterey:       "d27ba049c28fb3f5603d5c8b087be2a609c6b656ad8bc9c182c9b25ce1d6f7b2"
    sha256                               big_sur:        "1afb575de104966bfe952482c29cf8902256df5fa3326a264fc6d8792a182f00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c057a9de3768c5e808fb1f5de6f9604bce12ce202b552456f24a305d7c4f4e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = "/dev/null"
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~EOS
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    EOS
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end