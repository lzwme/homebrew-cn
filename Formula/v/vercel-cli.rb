class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.14.2.tgz"
  sha256 "9e7a91ad5c30e86779cb32f12d5b30aaab81d99f0c45545d8795633eb8b32674"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4a0deaed43866affb4d8057e87f0705ac84cd70c132cdef3e83997ea05e1de57"
    sha256 cellar: :any,                 arm64_sequoia: "75458c21e09cf532b9d66d684bd93d2ecefe0fa3ae153d9ab22abacc6f976215"
    sha256 cellar: :any,                 arm64_sonoma:  "75458c21e09cf532b9d66d684bd93d2ecefe0fa3ae153d9ab22abacc6f976215"
    sha256 cellar: :any,                 sonoma:        "65e42c8d41f53dd0631cbc778d92521ba49dd1be70b2cd1949950861d0161cfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e368f0d75e62954dcb78f4c3da592dd0da1355488a18fc27fad8378f731aa8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1ed7108e1d264b577687aa0cd48e6a29ab00c3b1249c1a1dbfe1105b4ad9115"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

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