class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.7.0.tgz"
  sha256 "6737c30f00d7fd8bd3afce77a6ce98d8c1509adfb3489834e5df72245e67bc62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "070a87fb8a78515ebd3da797f7e3e76da1614339fdd364a569dbcf8be16d527a"
    sha256 cellar: :any,                 arm64_sequoia: "070a87fb8a78515ebd3da797f7e3e76da1614339fdd364a569dbcf8be16d527a"
    sha256 cellar: :any,                 arm64_sonoma:  "070a87fb8a78515ebd3da797f7e3e76da1614339fdd364a569dbcf8be16d527a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f14772db4f3304f431f887a2822be95af4264243cbba3d03a6a3b57157f4223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67322e2d50eea67a2ef30f6ba6b664b80f57debb78c1d22a18232103bac74f37"
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