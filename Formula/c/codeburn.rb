class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.22.tgz"
  sha256 "16856cd5b910eb16a632ac3c875f93118bf37c1106e55461ced5f7316f4c8498"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "598f3c5c200316891beb286739bd947443962692ed1fb17b9d7d9ddf9cfd153b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "598f3c5c200316891beb286739bd947443962692ed1fb17b9d7d9ddf9cfd153b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "598f3c5c200316891beb286739bd947443962692ed1fb17b9d7d9ddf9cfd153b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eea38ab398ff9f01fee35ec306342900397b05cc059d5ac3c045ed8f3e8e4a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a570e083b2bb56a31abbb3d747867c2398df8df3acf4ce9737e30fddae047388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a570e083b2bb56a31abbb3d747867c2398df8df3acf4ce9737e30fddae047388"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end