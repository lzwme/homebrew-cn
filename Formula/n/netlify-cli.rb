require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.22.0.tgz"
  sha256 "2cdecd100d81dcf9f09c078494a811895739e2d64960ef052df5cf7f41a5bcb5"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "55ba6b4b0f61cca18b5ef0c4317297b175d01509ab4736e7a9235c56bd9f99fb"
    sha256                               arm64_ventura:  "29115c572192512714090e8c20508251a982adffc119058f334b91939577d2ce"
    sha256                               arm64_monterey: "e776fdc40757c16824933955fc6d618f827f844412f126d7badbffb300e2fedf"
    sha256                               sonoma:         "f2095fc5389be048f557fc0a4a7e7bbbf37ff9a2381bffb32ab265dab29394ac"
    sha256                               ventura:        "084b2229b7d77d1a46a6e8f524b3257e1721189bad4f3bdd499fc7ba8574d704"
    sha256                               monterey:       "1ee973f5e26562a3e821070e533d5bd0ab76ff96dc7016dc3a6eb831aa056c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "662b5d31aaa2c76100586eb764773962eca5510066437227a630c2ce1062eca6"
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