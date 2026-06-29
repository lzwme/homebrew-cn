class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.18.1.tgz"
  sha256 "37a1674f0fabe254c63aa32ce19748ef24b1b2b638abe9aca0352e4e48975e7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4de7e38bb93b63aeca25bc2a6ff6ee56b567e298750953273535cbc45d5b47f"
    sha256 cellar: :any,                 arm64_sequoia: "92c654edfa4226b812c8f1624c3d38c9523ffd553283ff20b1691a6a2231afcd"
    sha256 cellar: :any,                 arm64_sonoma:  "92c654edfa4226b812c8f1624c3d38c9523ffd553283ff20b1691a6a2231afcd"
    sha256 cellar: :any,                 sonoma:        "6e633e2055cc5ad92552320f7717fab9220d002cfa022b065e82630c8a37f295"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "138326727c9df224f8677f407433f6884816a00c5a407742e47a8e7a7f6f6895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fea00805bffbd7fc16b4a3ec1d729f8f34b528945ee27649ea021b39f853bcdf"
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