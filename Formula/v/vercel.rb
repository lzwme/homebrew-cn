class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.3.0.tgz"
  sha256 "47f19d656b69800cdd430bdc097d86b714f54dc372ce18f1518ebeab69815325"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f050aaa5ea2735bd4ef828ad00754bfb7153b01ac0d447ca74d0d7af9c7d4305"
    sha256 cellar: :any,                 arm64_sequoia: "f050aaa5ea2735bd4ef828ad00754bfb7153b01ac0d447ca74d0d7af9c7d4305"
    sha256 cellar: :any,                 arm64_sonoma:  "f050aaa5ea2735bd4ef828ad00754bfb7153b01ac0d447ca74d0d7af9c7d4305"
    sha256 cellar: :any,                 sonoma:        "f9f355e142212b2603c7664dfe849522203884c2ae8d9d1b0f5455d6747fe8c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02a88189a39225cddafbfeb3458f4d40d2e5d1b861754b757cf56ca177a3952b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0af4cb93c77e781f7c823b1dc5af7684628c2fa359f4da32d21270fcf3f3c0a1"
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