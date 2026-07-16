class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-56.2.0.tgz"
  sha256 "e110a3bf644a584e3071f88a9dc12289a3f134a902e4e5d4556cbada4691f512"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22fa84a3b65c76a84aedb89e3d15eb6d2f98478e688a7f82292a3198a861efb7"
    sha256 cellar: :any,                 arm64_sequoia: "22fa84a3b65c76a84aedb89e3d15eb6d2f98478e688a7f82292a3198a861efb7"
    sha256 cellar: :any,                 arm64_sonoma:  "22fa84a3b65c76a84aedb89e3d15eb6d2f98478e688a7f82292a3198a861efb7"
    sha256 cellar: :any,                 sonoma:        "ac45c44701beb5cd409870e9be3dc0687a271bf22dc541ce4bb476af750e61e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e9c155b59a78c3e8c705428978ff2706bbe9175e41688f0665ea90737cec1c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7eaef1860128866b62f825e3d46994bddd7cd8bfdf472a2662de03af8f2efb5"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

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