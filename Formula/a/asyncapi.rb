require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.5.5.tgz"
  sha256 "8105baddd80802654a321ef7727a93a4318623fa206392f04c632d56cd8c3268"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5bb348b3a8692cce4a855969ef010089b2f0aa2a1c000739c259a2aceabd8829"
    sha256 cellar: :any,                 arm64_ventura:  "5bb348b3a8692cce4a855969ef010089b2f0aa2a1c000739c259a2aceabd8829"
    sha256 cellar: :any,                 arm64_monterey: "5bb348b3a8692cce4a855969ef010089b2f0aa2a1c000739c259a2aceabd8829"
    sha256 cellar: :any,                 sonoma:         "e2ebd1169ab4bbd3a0b6aa992ee1807c5de705d17e06cdbb843f90ae035ffba7"
    sha256 cellar: :any,                 ventura:        "e2ebd1169ab4bbd3a0b6aa992ee1807c5de705d17e06cdbb843f90ae035ffba7"
    sha256 cellar: :any,                 monterey:       "e2ebd1169ab4bbd3a0b6aa992ee1807c5de705d17e06cdbb843f90ae035ffba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a8df1c2f4170ca1c11a0fb4de49d965b2fd92f0ec199a38426ffd6d805321e8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec"libnode_modules@asyncapiclinode_modules"
    (node_modules"@swccore-linux-x64-muslswc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end