class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.26.0.tgz"
  sha256 "1b8f8fa8e95fb35f7396427e5df87bee3de32f4c704af51129e6cf00e2885490"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "6d2af5c985e0dfd10b93fb111c149cf954c70e4f58ce5b1fd559deb95e4026c5"
    sha256 cellar: :any,                 arm64_tahoe:       "6d2af5c985e0dfd10b93fb111c149cf954c70e4f58ce5b1fd559deb95e4026c5"
    sha256 cellar: :any,                 arm64_sequoia:     "6d2af5c985e0dfd10b93fb111c149cf954c70e4f58ce5b1fd559deb95e4026c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d294612eb710347ad961e722223ab83326b8bb766049e445d542e74e9c98fc46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c9495a5afdec13539c11fd4fc81f85733cf01032526c0f4de58acdaa3e4c1789"
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