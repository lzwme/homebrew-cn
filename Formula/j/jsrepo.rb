class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.6.1.tgz"
  sha256 "58741028299f706d1a77c60db41d29e197643761d5d07f150f5c6b42079a61b7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61c4cf3f6f0c97c64f8a443c7880b36483a17a2345a1fc984dcc763869c770f5"
    sha256 cellar: :any,                 arm64_sequoia: "3f932e75d5d5b9e4baf4723947d8f337077ff0e4ab4fe5d6c69f43badfebe8bc"
    sha256 cellar: :any,                 arm64_sonoma:  "3f932e75d5d5b9e4baf4723947d8f337077ff0e4ab4fe5d6c69f43badfebe8bc"
    sha256 cellar: :any,                 sonoma:        "f36c303f86b93223182d9b16a6b5c0a43075fd7573145c9235330f75e55adb5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40ededda84bb799b63286216a89cd24f2581f15733d9ba4d3b63c9fdaeedf8dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1d978f07ed2fef7a62ae43326c0d39fdecb8da2a2aa7fd9eeabbbf1f8144004"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end