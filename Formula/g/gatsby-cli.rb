require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.12.4.tgz"
  sha256 "24e604fc2ddac7f5a011edc45f0711c97c1e6661b7e2c229ad401abaf5f41060"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "b726d9bd3c3611d89266e3336364b15d2c7bcbf9f504e36d356b5f967bb4d0cf"
    sha256                               arm64_ventura:  "ccd58311aba86cbfc6b6e0571b65af49d58797f75c430ba99f6d803c50596d09"
    sha256                               arm64_monterey: "5299d6ab829ecf6535e7a79f38943df1b9a6dc02d3e8a89816961fe5363943fa"
    sha256                               sonoma:         "fa9598e0605cb3b8de26b1d96339e624cfaa8e2dbc964ad18866642c66f54f65"
    sha256                               ventura:        "515bb758e5e62592322b99eba5c3dd3cdd69766a902255fd1796e55657f6cfef"
    sha256                               monterey:       "56523dfd0abb042e53852c656b8a31cede8e27988aca5e50dd759eac9c62c0c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4937f3e266ba7a345d7c67b76e2de48728867196d36c568d94c1dda638a60a1"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/#{name}/node_modules"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.linux?
      %w[@lmdb/lmdb @msgpackr-extract/msgpackr-extract].each do |mod|
        node_modules.glob("#{mod}-linux-#{arch}/*.musl.node")
                    .map(&:unlink)
                    .empty? && raise("Unable to find #{mod} musl library to delete.")
      end
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end