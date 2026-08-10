class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-58.9.0.tgz"
  sha256 "776d95ea55b22be00fbb0ade73790b6f414af008650d990123d4ed80f2f6b00c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a93c06bed7db77187c84a57026cbab795e37aec131bef1347995d7193d19bad3"
    sha256 cellar: :any,                 arm64_sequoia: "a93c06bed7db77187c84a57026cbab795e37aec131bef1347995d7193d19bad3"
    sha256 cellar: :any,                 arm64_sonoma:  "a93c06bed7db77187c84a57026cbab795e37aec131bef1347995d7193d19bad3"
    sha256 cellar: :any,                 sonoma:        "3d0dfbbd3f2eda16f09911b4c022a4a253ecd3a2b6e281cd762cd6d571a7264b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11b56864d69bbcc99518ae27ea2367ed8b453c4ce213de14a482e5097dc821a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2359ab4aad3eecc1ae9aab6f07fcd862f4d93120bea94a222eb4a96dde48df2"
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