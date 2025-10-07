class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.2.tgz"
  sha256 "ac67b426f7b9f39cd4270539c7f5da924796c1dee87a5ab3fddf9643c1789435"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d2c0a10cca18f8d8f510d23c3ba91fac8caa9858a9a2c1c8b717ade9adb2ed7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d2c0a10cca18f8d8f510d23c3ba91fac8caa9858a9a2c1c8b717ade9adb2ed7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d2c0a10cca18f8d8f510d23c3ba91fac8caa9858a9a2c1c8b717ade9adb2ed7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d2c0a10cca18f8d8f510d23c3ba91fac8caa9858a9a2c1c8b717ade9adb2ed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d2c0a10cca18f8d8f510d23c3ba91fac8caa9858a9a2c1c8b717ade9adb2ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d07c1c020a6e6612e5044adb806e7308e418f8e48ed7038dcb3e8be71e3435"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end