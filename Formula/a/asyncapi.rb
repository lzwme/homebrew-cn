class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-4.1.0.tgz"
  sha256 "734e954408496450b7adbea8fafbea7cfdf0f507a4a16ae48b46f485ebff0889"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e6cad185e6683d606f371d952be5cd356256a58654c3c36813877130c7a3e95"
    sha256 cellar: :any,                 arm64_sequoia: "418c486986a41825a1c486b70820737e8e6fc3b5ffab61eaba5ca4c9910825a5"
    sha256 cellar: :any,                 arm64_sonoma:  "418c486986a41825a1c486b70820737e8e6fc3b5ffab61eaba5ca4c9910825a5"
    sha256 cellar: :any,                 sonoma:        "37b92749ad75602fc7a841dafc8fab3acf8e72f6ccabe3bf5dc984757df08bce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d245bdd5bbd238b2564dd96d884e9b68241bd9e1819591b474a65951331bfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d49d355c26f90e6e49d6b3a51d3a06fcae50cb2019b3768ac3f17d9b3e41ad"
  end

  depends_on "node"

  def install
    system "npm", "install", "--ignore-scripts", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end