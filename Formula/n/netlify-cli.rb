require "languagenode"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-17.15.1.tgz"
  sha256 "6b33988b41ea40081ee0fbef4927062b8a72dedb645612e5ddae10883975915b"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "fe2de45ff4004a0f2dddeeb3cb3e3fc62deee4b54e3572e2edb15d23053678d1"
    sha256                               arm64_ventura:  "4eb0c603d9eda29fd60c9319429da1e077bcc4db42d153fffe48a03194674a37"
    sha256                               arm64_monterey: "8c0c58112c6872624a93ef6b6c6b371f56ee4170600fa3aacd4b8ac4f3ff091b"
    sha256                               sonoma:         "315dab7a3886cbe7aa1a05927b13b45b55895550af38656289a41e114663ebfd"
    sha256                               ventura:        "a72a3dbb723dc6cb79b4b7614d12dd9b6e310f49c0c9f7e240792fb27ab2127a"
    sha256                               monterey:       "77fbd7bc8c651d99591763a583eec5ed955d64cafd41f1e2c3564ec138641966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61fcba2685df90e15492bea549068e8074539900fcc62cdb777743e066ae66fc"
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
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end