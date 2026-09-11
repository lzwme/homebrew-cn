class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.15.1.tgz"
  sha256 "561e35c01ba48ec04b680b59e06575cf9aa454b8d7c867d2d3708a2326c834e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "14ab11e5cfc549a45a1abb06b854f8d676ad7f06f48f0dda4d6373cd319bfc3d"
    sha256 cellar: :any,                 arm64_tahoe:       "14ab11e5cfc549a45a1abb06b854f8d676ad7f06f48f0dda4d6373cd319bfc3d"
    sha256 cellar: :any,                 arm64_sequoia:     "14ab11e5cfc549a45a1abb06b854f8d676ad7f06f48f0dda4d6373cd319bfc3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1f98a036e3469834390f12f4918f8e69ddba975743ee84dbab5a9aaf2ba33de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6ebd527a24f3f6cd22c3732c42a1223475320caede5e9ea64f98e9bfe1bb946f"
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