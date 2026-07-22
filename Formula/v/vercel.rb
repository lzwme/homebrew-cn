class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-56.4.1.tgz"
  sha256 "de22ee9b7fdeda9dc4556b16b8097c61e3849a921992ebc4fd2535f0790e0a06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f325ea39864b120f9e03288728ca95062b4be1601741abef1441e463bf07914"
    sha256 cellar: :any,                 arm64_sequoia: "0f325ea39864b120f9e03288728ca95062b4be1601741abef1441e463bf07914"
    sha256 cellar: :any,                 arm64_sonoma:  "0f325ea39864b120f9e03288728ca95062b4be1601741abef1441e463bf07914"
    sha256 cellar: :any,                 sonoma:        "25c98e8b4e43c503730068b1a327771d3f1f692310ed0f1fb55701027e0c6999"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043df8be4961290d02f4d2fbb926887541d30820a19da4dfe99a1f98d7ed0b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adc5e67542cf61d0d84b5571c89ba506ebee219190164c5ef2b042c580a42a48"
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