class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-62.1.0.tgz"
  sha256 "638a4d8b6944ca6d562f30e3199154288c65ce28b7dd1899a83e3d184c85cef1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "7d5853572a3f3f741d78a0578e41eea726ce29e10143f2e3c055d61f5629549e"
    sha256 cellar: :any,                 arm64_tahoe:       "7d5853572a3f3f741d78a0578e41eea726ce29e10143f2e3c055d61f5629549e"
    sha256 cellar: :any,                 arm64_sequoia:     "7d5853572a3f3f741d78a0578e41eea726ce29e10143f2e3c055d61f5629549e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e69af49d2cd5308ec1cb7b6534b3e6ecf7b165a76be4a4d33578d543887caf7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "16539e8f26f731b0682f38524a524a899caf42f61d1280ec3a827fd2f1f981f3"
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