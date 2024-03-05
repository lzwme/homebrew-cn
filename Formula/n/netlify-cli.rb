require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.17.2.tgz"
  sha256 "ae97b61cab2f5c974f4ce62ee79f39b3aa20eb418640bdd92666db17ec73ab27"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "7df27997c804e0d091d08665c25b422479945cf19580c029ba22b5feadf729ac"
    sha256                               arm64_ventura:  "2609d7a19728cecb1c930a466002b3c35666e37b6f97a417ffffc1e86964425f"
    sha256                               arm64_monterey: "7d338cf6ef28ed8b1eeb75c9303d003613995953fc663bfa23e110199d2179ce"
    sha256                               sonoma:         "d2004c348f3dcc9cceccacfbc3c9942ced881799b420e094841ae40a1c1c2784"
    sha256                               ventura:        "e43400675f268656dd2a24a135ff6599c89e4af472e9198082d9625c9c9037fc"
    sha256                               monterey:       "e4d5428cba72e610dcec07ec37137a95d70c594f423f4377596c0cca282e2635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4982321e78919ca7aa08e3570f13a030aa1b40db6421c60cb4807ab35b337e6f"
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