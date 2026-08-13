class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.9.4.tgz"
  sha256 "d2a8399215bf6a2bdb66695c7e9ef87ef643d86cbfcb29c16a4b5ba486d283e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2bd89dc07a549d6da284a8d85fc2f3eae7716b037483592fcec8c7a0f4b97370"
    sha256 cellar: :any,                 arm64_sequoia: "2bd89dc07a549d6da284a8d85fc2f3eae7716b037483592fcec8c7a0f4b97370"
    sha256 cellar: :any,                 arm64_sonoma:  "2bd89dc07a549d6da284a8d85fc2f3eae7716b037483592fcec8c7a0f4b97370"
    sha256 cellar: :any,                 sonoma:        "36a1a0c8579d26a30b36e7f9996209bd143e027f9d84f801490b0035fda9055c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0729a191a83414504f1028ccb998b31f54bc2edb75000c2dbc586a65945b8360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29bc25538d6da1971a654ff206441768685fa23c85c99fede1f2abcd4593e368"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    (node_modules/"@vercel/go/bin").glob("**/proxy-*").each do |f|
      next if OS.linux? && f.arch == Hardware::CPU.arch

      rm f
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end