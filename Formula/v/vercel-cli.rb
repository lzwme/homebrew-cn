class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-37.4.1.tgz"
  sha256 "7f7c9f0bf8a6274347b2f63cbe1267cebcbde5cb8b32387acdf65b30e7e54c3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1dc23c664698832c32119f4253a4240661fc4cff4ae6ba7312cc9d8dff22a6f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f528cf89a91d79f4f748d907c2ebb9651e6835cfd8a965203b4dfec92faa59a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f528cf89a91d79f4f748d907c2ebb9651e6835cfd8a965203b4dfec92faa59a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f528cf89a91d79f4f748d907c2ebb9651e6835cfd8a965203b4dfec92faa59a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd35e5852f18c525722e7a9143b62a08c0106c77d388a87e0c8d8a27971a169a"
    sha256 cellar: :any_skip_relocation, ventura:        "bd35e5852f18c525722e7a9143b62a08c0106c77d388a87e0c8d8a27971a169a"
    sha256 cellar: :any_skip_relocation, monterey:       "bd35e5852f18c525722e7a9143b62a08c0106c77d388a87e0c8d8a27971a169a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aac3bf3b030595368078a0d6e96e7ad213620fac9499d38e57d7873b1feebc9"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end