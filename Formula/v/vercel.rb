class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-57.0.0.tgz"
  sha256 "e72de712899231c34d98be457bbf58a896b39c419f758960233a68ac26422ab1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fa158cfac0d96c12094855e3cbfaabe5c0bd6048bcc517af9fb3700d961727c4"
    sha256 cellar: :any,                 arm64_sequoia: "fa158cfac0d96c12094855e3cbfaabe5c0bd6048bcc517af9fb3700d961727c4"
    sha256 cellar: :any,                 arm64_sonoma:  "fa158cfac0d96c12094855e3cbfaabe5c0bd6048bcc517af9fb3700d961727c4"
    sha256 cellar: :any,                 sonoma:        "bfd3b553c4e6e7b5ba27a82c20a737ccbfe5330f93187b6509cbbb8a62640e2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec0572e79498282a31dd983629501602c4ec23d4f15ba9634a760553d4003fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac8e0a7416fed2308a5cd73803db925f75b87a7e752df6fd831cb50d44134b42"
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