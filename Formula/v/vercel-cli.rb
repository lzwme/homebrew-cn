class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-56.3.1.tgz"
  sha256 "d50d9351f3ee87c8fcbc7a47f9a84f4dffb815f1a0fedb8d6b49829bdc20b15f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "727a62eede67b88b796e78a7b39b88cc26882367548c401a2cdbd07b48d10f28"
    sha256 cellar: :any,                 arm64_sequoia: "727a62eede67b88b796e78a7b39b88cc26882367548c401a2cdbd07b48d10f28"
    sha256 cellar: :any,                 arm64_sonoma:  "727a62eede67b88b796e78a7b39b88cc26882367548c401a2cdbd07b48d10f28"
    sha256 cellar: :any,                 sonoma:        "cf6b5473d2f57d576bf16f320e6ea4d018afa0ebfb42452443362e6de85eed56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66fd57b248b1fde5634be458b126a623ae54a5ef523e4562b823c4c31842393d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "033260148b73fcad239d61c36ae294c000808b6284eae7c374b828e0214d0255"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

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