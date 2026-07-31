class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.4.0.tgz"
  sha256 "bec891054dac607029cc7cc9528e6478c7a24dda5c028c749d6c42ce47e20469"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "477cc8b9ac76a027d2e0ac25df1dbd263baec4be7a87663a5ddd3a835914afda"
    sha256 cellar: :any,                 arm64_sequoia: "477cc8b9ac76a027d2e0ac25df1dbd263baec4be7a87663a5ddd3a835914afda"
    sha256 cellar: :any,                 arm64_sonoma:  "477cc8b9ac76a027d2e0ac25df1dbd263baec4be7a87663a5ddd3a835914afda"
    sha256 cellar: :any,                 sonoma:        "59fba2aaddf02c7874dc9fecb1df51f8bfbddde6280f2fcf8944ad5bd2a9db0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a202200cc33fa7d2ebfe4158913d411a353f00a0b1dc7d7c8430afb301b37462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da200af6d1fee3563740e65a26acef2307cc446653610b668c81c855176ec301"
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