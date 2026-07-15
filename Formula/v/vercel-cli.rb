class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-56.1.0.tgz"
  sha256 "26ec84ee990604e3d145c2abc3da8ce9618b140e926bf25e09963af916c1f6fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dff0fdea4a5932a7e9747fcc2e0d5d0e78f838263e6ccb11409d8dc981ada597"
    sha256 cellar: :any,                 arm64_sequoia: "dff0fdea4a5932a7e9747fcc2e0d5d0e78f838263e6ccb11409d8dc981ada597"
    sha256 cellar: :any,                 arm64_sonoma:  "dff0fdea4a5932a7e9747fcc2e0d5d0e78f838263e6ccb11409d8dc981ada597"
    sha256 cellar: :any,                 sonoma:        "be8b5f4ec93d67a2496b3c19aab1fad3cec713151382aefd78c900b2a617b996"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e4fb55befc24f3f59610acd16ea2e1499345486e2182fd5474c70eebf9c7ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcf1fa12daef1a9c3ef832fc3c5958c32d5c7b91672607bc2065a351a80cfd8f"
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