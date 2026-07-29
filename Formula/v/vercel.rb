class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.0.0.tgz"
  sha256 "5e3c7a3daf041bf6425c5950372db39742d8c4374a9e0b3f2c22ab19d60c2770"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6d05fd2689b344f5374df5852c58b4f42631c5a72cd27b6940bb72face1c72f"
    sha256 cellar: :any,                 arm64_sequoia: "b6d05fd2689b344f5374df5852c58b4f42631c5a72cd27b6940bb72face1c72f"
    sha256 cellar: :any,                 arm64_sonoma:  "b6d05fd2689b344f5374df5852c58b4f42631c5a72cd27b6940bb72face1c72f"
    sha256 cellar: :any,                 sonoma:        "6914d4d337a41632c48636a9b34db5c594528f24b9d48950771c6dd7e3c109a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "732a1dcc2d3f9f85e916061ae1a978e31af491b504a5c2c0f0e878955b7c6f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9945e461031fa02f55ea68fda6e9d8e16c3a9f3f595f31b677aef4166c898199"
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