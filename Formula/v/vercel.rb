class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.11.7.tgz"
  sha256 "34432b6f0ddd6501ab17140dcf6c5baa2e68fa1ce91eabcb2afef4fbf4db44eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cf49df39c5b3fd43ffae0dd75e9985300f4de086afa355296fd2078683a13fe"
    sha256 cellar: :any,                 arm64_sequoia: "7cf49df39c5b3fd43ffae0dd75e9985300f4de086afa355296fd2078683a13fe"
    sha256 cellar: :any,                 arm64_sonoma:  "7cf49df39c5b3fd43ffae0dd75e9985300f4de086afa355296fd2078683a13fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b3f3a1e56a950839e6af17509b92c3edc5ac2f4c0cd763d3e65bb1b4b15354b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b0b1ffd72e68d1a5fae34a7f2b3bcf38e128b275cef5552d02e94ec12e0bbf"
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