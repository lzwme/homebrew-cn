class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.8.0.tgz"
  sha256 "d99a788ea9ef9c9d83667690993e926f6eda8c8b5fd97bfabba78a388d7cc913"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "057806f7a6c8b7640d3adc0b3809ae92507ae7ab5a493302362c4c39a89a8d16"
    sha256 cellar: :any,                 arm64_sequoia: "057806f7a6c8b7640d3adc0b3809ae92507ae7ab5a493302362c4c39a89a8d16"
    sha256 cellar: :any,                 arm64_sonoma:  "057806f7a6c8b7640d3adc0b3809ae92507ae7ab5a493302362c4c39a89a8d16"
    sha256 cellar: :any,                 sonoma:        "b3b9daeddc5e45a63e43378e27c3e3e50c9ce936755ac6d60c0400fbb93dce5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "548607714c87d43d94ff5037340e0ab6ac0592e139700b4f4bfb68f54ebcca83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c99900ff89f701c125a4a8d839e865b2eb6a6d73451689ccbe3db98b4eb28132"
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