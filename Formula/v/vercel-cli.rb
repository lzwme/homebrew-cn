class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-52.2.0.tgz"
  sha256 "8690331bf27b50ecc10415e2037241726ecd4bd24ebe00285a117ac13d9e5593"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "83a4090da39c483711d20e89a35b5c27765c59e1d284f618a9f93142056de5dd"
    sha256 cellar: :any,                 arm64_sequoia: "774342b634819cbcc7a3b769a81e93c854c9d670f4e03cbe64f8b1527e9b3416"
    sha256 cellar: :any,                 arm64_sonoma:  "774342b634819cbcc7a3b769a81e93c854c9d670f4e03cbe64f8b1527e9b3416"
    sha256 cellar: :any,                 sonoma:        "64291ce5ffaf03e9edd10cfb3a332d6529eb492a1d3d156f4428966684bf4523"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ee999b168cc73d0e736f5fba4ef9ac22a42bfb5a9cf999f4a7f0abb29da7d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03152eb910213f2c726b432dd9099da58a747c4197e1df3c66ed8276fdafb8d3"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end