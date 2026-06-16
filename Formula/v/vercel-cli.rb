class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-54.14.0.tgz"
  sha256 "b3aab02f7b59945ad454052ac84d36bbe91f66613af4c0947cd5cf06932f774c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1f25bbe0995f46e21e658d46a37d474a6085611814d7fa112ffdc0e9dba45b9"
    sha256 cellar: :any,                 arm64_sequoia: "c272e068902019bd07b84d13b5f8698c1d047730a1e3d94a8ce9c2389250bfcd"
    sha256 cellar: :any,                 arm64_sonoma:  "c272e068902019bd07b84d13b5f8698c1d047730a1e3d94a8ce9c2389250bfcd"
    sha256 cellar: :any,                 sonoma:        "b41169ffe3a4dda5e4bc620079f56efe007f97571c9ea67144a87e99c0e37acb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e5b320080beb020f5e789082f43e0ab44d222a5ba2874904f6f78e9dae352d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "732c626c9d9963d5b201e91496eace63bdbb73edf5c63168b44dc0165a805652"
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