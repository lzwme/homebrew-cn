class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.12.tgz"
  sha256 "549b183f277dfdf766b356dc7e0e20cb6ca070650cde7936bc126071ea2fe606"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12fb210aa09b1256a18175db7b7aea185a10ae9c292a3f7572508e379ca47755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12fb210aa09b1256a18175db7b7aea185a10ae9c292a3f7572508e379ca47755"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12fb210aa09b1256a18175db7b7aea185a10ae9c292a3f7572508e379ca47755"
    sha256 cellar: :any_skip_relocation, sonoma:        "568db272ea6aaf328b77237c614cc8a26d3459afa9a08010ab24d94871511fdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "568db272ea6aaf328b77237c614cc8a26d3459afa9a08010ab24d94871511fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "568db272ea6aaf328b77237c614cc8a26d3459afa9a08010ab24d94871511fdb"
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