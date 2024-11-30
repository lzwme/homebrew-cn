class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.11.1.tgz"
  sha256 "31681640b058085603937dd4f5c916401211aa63d94e226a4a27818d832f8519"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9738d0431719bb459934b287245972e2858296824bc0960ed5bc6744d1ca9809"
    sha256 cellar: :any,                 arm64_sonoma:  "9738d0431719bb459934b287245972e2858296824bc0960ed5bc6744d1ca9809"
    sha256 cellar: :any,                 arm64_ventura: "9738d0431719bb459934b287245972e2858296824bc0960ed5bc6744d1ca9809"
    sha256 cellar: :any,                 sonoma:        "4863d1b205d62a17e1e383e1fe8ed1e9ce844a076180fd8e3414f5b339099836"
    sha256 cellar: :any,                 ventura:       "4863d1b205d62a17e1e383e1fe8ed1e9ce844a076180fd8e3414f5b339099836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1439cecf196e3607a75594546c656e68a5884f63603c2b74f8385d012a81921"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end