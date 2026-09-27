class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-60.1.1.tgz"
  sha256 "2c388e63afaf22199195e3219ab924fd17deff025ffb7ac6d28bd388a5209f87"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "cdf9df9b48faba0e315eba626f433a3c975c591ab7462c827eaef299c1c48158"
    sha256 cellar: :any,                 arm64_tahoe:       "cdf9df9b48faba0e315eba626f433a3c975c591ab7462c827eaef299c1c48158"
    sha256 cellar: :any,                 arm64_sequoia:     "cdf9df9b48faba0e315eba626f433a3c975c591ab7462c827eaef299c1c48158"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c07c3b77df0f2c3600893efe2afcdee0fbb1cd93089b22940bef275f54d617dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ea8ae3c5bc1846745fc2c6aec2c828ef03f081778a77e882f5e86dce1f89cb5e"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end