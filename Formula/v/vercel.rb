class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-63.1.2.tgz"
  sha256 "d0f688e150204c24a09d41e3370062ea8a9413f579488ea76ef54362fe427cd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a10e1ec7d759ebdd9d88f6c7e240981d0a5d2fc75f1d2ec9124768653107ae55"
    sha256 cellar: :any,                 arm64_tahoe:       "a10e1ec7d759ebdd9d88f6c7e240981d0a5d2fc75f1d2ec9124768653107ae55"
    sha256 cellar: :any,                 arm64_sequoia:     "a10e1ec7d759ebdd9d88f6c7e240981d0a5d2fc75f1d2ec9124768653107ae55"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9e4449d6c6c0b93e7476535f60dd4e68b096ec63686d289c786a4778438074ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2acae252d574c26fcea6c217494ff13992f06f7d8c0f8a8b3b7a80c1295ef668"
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