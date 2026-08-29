class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-59.9.1.tgz"
  sha256 "585f8fe39acb7bed3c8fe5a1595adbbaf6c6f46989c3a2ec81704b70d7680a05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93e20705a81a2465f209b59921af233cfd1e77d56ada005175a978173618313d"
    sha256 cellar: :any,                 arm64_sequoia: "93e20705a81a2465f209b59921af233cfd1e77d56ada005175a978173618313d"
    sha256 cellar: :any,                 arm64_sonoma:  "93e20705a81a2465f209b59921af233cfd1e77d56ada005175a978173618313d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7965bf4b03cbb01a03d0569b176a1b17004900675bd6036224c90b9d877cb43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9bb9574ec2c32f690f5200aa9a5022c5a57a3c17dee2c339809a707ab5a858b"
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