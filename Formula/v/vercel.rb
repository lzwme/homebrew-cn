class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.9.1.tgz"
  sha256 "a9f05d07a3c5cd929b38bb09b0ebaa6dc830dc55ace74f62f81e326f0056973a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f54baf71def89eb0756649128643cab8028a225815a06303db651586b4aee78"
    sha256 cellar: :any,                 arm64_sequoia: "9f54baf71def89eb0756649128643cab8028a225815a06303db651586b4aee78"
    sha256 cellar: :any,                 arm64_sonoma:  "9f54baf71def89eb0756649128643cab8028a225815a06303db651586b4aee78"
    sha256 cellar: :any,                 sonoma:        "d5c68d28ab107a81ac48d653c4addfb2b38c8f60b5a27f1702a8e5f2360743c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e272ba4e41b41a75f0592f82a987fd5bd732a778eb6abff03941c36118a89e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "821724374a8d4dafc292dd042acec90003db6eda6a00dfa511d87b0e764aa1c3"
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