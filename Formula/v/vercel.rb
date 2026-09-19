class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.23.0.tgz"
  sha256 "5f238f21c6e810be867fdb1e4a74f40dc36059d0f777bcbd1e6857e0e5174caa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "c14e5f8588da85043a61b703fceb6de8833029b0049c3cc65359c34add432ff0"
    sha256 cellar: :any,                 arm64_tahoe:       "c14e5f8588da85043a61b703fceb6de8833029b0049c3cc65359c34add432ff0"
    sha256 cellar: :any,                 arm64_sequoia:     "c14e5f8588da85043a61b703fceb6de8833029b0049c3cc65359c34add432ff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "249ae15e71383e584523ac9cda2d06b59e681e6cc15a505fa7411fa30ec8ce56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "52042f8766617d4b803e25a2fab513ffb9de2b57338afe6cde93a44cc3cb3b9b"
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