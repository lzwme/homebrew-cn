require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.17.1.tgz"
  sha256 "3f84075bb7c4eebaa25aeb9d15b5d80329385c9436202e7b700b917352d3be59"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "5975d32aca84aa294f7be32c625414e14b9e03acb33e579a173f6c84ac58db9e"
    sha256                               arm64_ventura:  "875c7db9de1cfbcc87c6c4e781f8b3475b7648c8a3769c2682da65fd7d90c367"
    sha256                               arm64_monterey: "64b59662ad563d1249f72911aea9e732d089b7bc02159998f9116648be2aaf55"
    sha256                               sonoma:         "7334adba0e0983c3191219ee93fcea70539c2a96e3ae2f1b93f0a3b7b1c0a04d"
    sha256                               ventura:        "927365fc08ac6b417668249ce64ed7efc30d05718dfec37df73c2b74dfde2c80"
    sha256                               monterey:       "029f60b593171cdb50069a2488d6fcc27d04dfff2b704bef7023a2176903c302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e6cf3a51495b6046963c45279cdd96ba68862a33bf9e69608a063268b3eb8f"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec"libnode_modulesnetlify-clinode_modules"

    if OS.linux?
      (node_modules"@lmdblmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules"@msgpackr-extractmsgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules"@parcelwatcher-linux-x64-muslwatcher.node").unlink
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs``bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}prebuilds*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end