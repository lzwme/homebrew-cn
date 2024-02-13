require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1279.0.tgz"
  sha256 "38922377697dfcc6f13ef18b9b93d6ba259e690592e159d32b614e7e27aa1179"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "339b72e3e7eea63fbfed3ce8111b38985454f8d1e63518ee7f633ffc8f8e1ce0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03635d7e501bf04f3f53237f483a61a58f714ea32f2aad51b3c59a66781f0afd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c5a5a046153bb730390403589a85194eab43a2974f425d24fb590f549d7b226"
    sha256 cellar: :any_skip_relocation, sonoma:         "147ccef46fd128b5bd8f99b4f46dfe5a2502bb8cc195e804441fe70373259510"
    sha256 cellar: :any_skip_relocation, ventura:        "26d8cd34fd57d9d10c668292e520526c5bbd25b03a0b7bab59cec9f21404b2af"
    sha256 cellar: :any_skip_relocation, monterey:       "905bab48fbbf7235ffc1f2b7962d4f26d9a8e64e0a639d9c7f412159c71114f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a43bddd337c442ba97c81abbbeeb8ef1c1df56bee08e02531d544769fb07f81"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end