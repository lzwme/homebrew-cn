require "languagenode"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https:www.gatsbyjs.orgdocsgatsby-cli"
  url "https:registry.npmjs.orggatsby-cli-gatsby-cli-5.13.0.tgz"
  sha256 "04f9ab04c3b6ea1174f1db9c37d0c6a67a9419cf523b606e44ca7542476cd12b"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "881e0ba144acb5d58b6e572ca1c87455114b8705cfe35acf41efb943edd79055"
    sha256                               arm64_ventura:  "e4aa35a18bb3352019f5a95e7c26e841299767fda3e0681d7eefb0470b2bffc5"
    sha256                               arm64_monterey: "b67fb501d952842e6dda30b348da88d1677c184ab0075cba3836c54c24db1e3a"
    sha256                               sonoma:         "e5c7339433466ecabef0c58f22083a398ad2aeaf69cfcfd23bab9f966b60e14e"
    sha256                               ventura:        "429d3a94d2472e32dba1c0e4effaee54e7b5575d7dd948320ec7dff0d0af2206"
    sha256                               monterey:       "d8a90027a4efa0a5335ee570d009afdeb159c4c65e0f1d38bab20679c040380b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e7b5cfc9a0038fc5d9f9486ccd678878aec8a657e4e50c2bf8d19d37dd0f6e"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec"bin*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec"libnode_modules#{name}node_modules"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.linux?
      %w[@lmdblmdb @msgpackr-extractmsgpackr-extract].each do |mod|
        node_modules.glob("#{mod}-linux-#{arch}*.musl.node")
                    .map(&:unlink)
                    .empty? && raise("Unable to find #{mod} musl library to delete.")
      end
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    system bin"gatsby", "new", "hello-world", "https:github.comgatsbyjsgatsby-starter-hello-world"
    assert_predicate testpath"hello-worldpackage.json", :exist?, "package.json was not cloned"
  end
end