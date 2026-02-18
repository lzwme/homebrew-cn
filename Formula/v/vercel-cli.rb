class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.18.2.tgz"
  sha256 "67fa75d4843dfa10e341e2fb9c6d20345830a00300e2da6307a5b970533d5c28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "099e3c25fb4da53f61698be0fc84381da00d0217ae07841594844cb6956e7895"
    sha256 cellar: :any,                 arm64_sequoia: "1e977d4277815425821d11a0e5c161ae7367db689cf2b2ea24d7357640a7f9de"
    sha256 cellar: :any,                 arm64_sonoma:  "1e977d4277815425821d11a0e5c161ae7367db689cf2b2ea24d7357640a7f9de"
    sha256 cellar: :any,                 sonoma:        "93a0f872670c47ce756e697140fa057df1a79945bf80eacba88c0deda3a66a58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e37afdfe695256e34822a95cf3807efeb25298971c13fd9be90f794d23fc6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9171d751f175a4fd30c8a6902dbc38792b3a429c37bb671dca381c4a78e470fa"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/vercel/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end