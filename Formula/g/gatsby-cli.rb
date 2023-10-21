require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.12.3.tgz"
  sha256 "08f7a5003d9cdcbcbb26a55cd644b1ca2ba0d8bbce139f16a51f69ad2ca19660"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "247187bee68caff856c76442a5d3942ef15d80f10bba59ac20b3afdfaa3de0c1"
    sha256                               arm64_ventura:  "7eaa119eb253ca6b72a82e500c476f1706a483ba7677253f7b12bcf4e0323b19"
    sha256                               arm64_monterey: "f55600f30e8103fee9790d6d34dc38e8387fd6b60c79de9f32f6caf3c4f2aae3"
    sha256                               sonoma:         "e4db91b5dc6b6c3e3fedd4e090b44e197b8dacab901638a9e30cd2273680e2e8"
    sha256                               ventura:        "51519ff80a2c322dd876fd8f8fbcfc2f87fa5aeae4212ad487e73b3a589abaea"
    sha256                               monterey:       "5e65b68229c6793b4e09dab51d653a324b66b07ff93ceeda291f8a55aec2ef03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f66ce5a2ba51f4f8b5f20d2caf515a3134ec26e2056f1312b908f1314520adb"
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