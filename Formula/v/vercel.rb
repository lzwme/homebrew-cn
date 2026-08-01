class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.4.4.tgz"
  sha256 "24d2c3b3d213c97afaddda9b92c9bd34786dbb47cf2f55bc7d7639d326a7d424"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69ef8bec8a7c36ec6db562d1fa10595e0c3ca2d08dfc5ef8416c7f0d1a62e992"
    sha256 cellar: :any,                 arm64_sequoia: "69ef8bec8a7c36ec6db562d1fa10595e0c3ca2d08dfc5ef8416c7f0d1a62e992"
    sha256 cellar: :any,                 arm64_sonoma:  "69ef8bec8a7c36ec6db562d1fa10595e0c3ca2d08dfc5ef8416c7f0d1a62e992"
    sha256 cellar: :any,                 sonoma:        "3fd042fb2a7feaf1da44285915f3f7925fc57a7caa8bfdb9c859530ebac130d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bae51724cc4a092f31ff4e7d7cc5d824f5ad936999222e7c25184ce921c0367c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52467f578c3dea79b83ee6d61d93d3705e8715af25cb5e72477bb5845906b69a"
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