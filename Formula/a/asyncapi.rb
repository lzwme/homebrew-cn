require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.9.3.tgz"
  sha256 "64a52af65e6f31c9c561ec924a98b002df44283f48cea32a71aac94b74d2f647"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "604d55648b72a57e6dfc47cda468deaf3cf55844abc2eecdff68f2523b81bac5"
    sha256 cellar: :any,                 arm64_ventura:  "604d55648b72a57e6dfc47cda468deaf3cf55844abc2eecdff68f2523b81bac5"
    sha256 cellar: :any,                 arm64_monterey: "604d55648b72a57e6dfc47cda468deaf3cf55844abc2eecdff68f2523b81bac5"
    sha256 cellar: :any,                 sonoma:         "e2037b33df9697a7de91361e0290ed4bcb843ca48971ebf2807f432c6b18f2a4"
    sha256 cellar: :any,                 ventura:        "e2037b33df9697a7de91361e0290ed4bcb843ca48971ebf2807f432c6b18f2a4"
    sha256 cellar: :any,                 monterey:       "e2037b33df9697a7de91361e0290ed4bcb843ca48971ebf2807f432c6b18f2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "140577a9a69e28671389ffe7b04974f9d0a68ec68f2ba3d5f5f46343b614380f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end