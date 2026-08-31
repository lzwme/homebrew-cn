class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.23.tgz"
  sha256 "1d7f3bd3e45af6bbe167e25468b5cfbf5a3d137139327a77564f39707e214a50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8d1fd4d3393ba7dbb033b48af617764796cb97f4b240643897d6c0ed7fb6d29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8d1fd4d3393ba7dbb033b48af617764796cb97f4b240643897d6c0ed7fb6d29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8d1fd4d3393ba7dbb033b48af617764796cb97f4b240643897d6c0ed7fb6d29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a6038c5c02ebf9f6feaae27a5960fd8a369505fcef80b527785cfd36c9e5a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a6038c5c02ebf9f6feaae27a5960fd8a369505fcef80b527785cfd36c9e5a25"
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