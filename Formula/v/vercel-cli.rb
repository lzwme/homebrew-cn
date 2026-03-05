class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.27.1.tgz"
  sha256 "ac2e5d6a38276d561d18f9567128a00e4bf9e39f168f0f55b962fad857c230ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37e9e2322138c9c23ef937d6333a55807ef2018a05ad0f1fea64cd07cb486bc3"
    sha256 cellar: :any,                 arm64_sequoia: "aeb802e938757ef0a477d51cc08bc36833dbbf8afd31ae01da1aca5228e75ce8"
    sha256 cellar: :any,                 arm64_sonoma:  "aeb802e938757ef0a477d51cc08bc36833dbbf8afd31ae01da1aca5228e75ce8"
    sha256 cellar: :any,                 sonoma:        "c4ccc3c787cb59af574aa2ddc35e1e797287a1f5f206792a5ff067a6f2e4513b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0efee996b7879bc9ef366f37ab8b82ced8c38809cb38e814109984d0b4f0e2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "035f79237813b3fd45700677e26139276d8e1553ce171ee84adaed8ff5924353"
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