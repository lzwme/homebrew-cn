class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https:www.netlify.comdocscli"
  url "https:registry.npmjs.orgnetlify-cli-netlify-cli-19.0.0.tgz"
  sha256 "6f9d9db9744026ee64564894ec3798980883412f70ed42566dfaa1232fc41f01"
  license "MIT"
  head "https:github.comnetlifycli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "1cd118d6251773003a09be432cc235c0ea28365c1157680ad0df59a02b174a49"
    sha256                               arm64_sonoma:  "a516b8b4b8c4d2efa128b822245bbb00e27d634fa8cd2a3eebc6e361bb47a527"
    sha256                               arm64_ventura: "cab3962efb6181d0453295a21a66d39b806f3e256d3603fac698f37de53e7fa6"
    sha256                               sonoma:        "2dbcbcfc550d305f5517f7a8e390644d7c87a065ba06aa1cf35fed2df32db5a1"
    sha256                               ventura:       "eb5ff1584542d4ba8ec32501fc91f85f09fa9e6c3492cf0150b4051168ca86f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a955d2329866075210b0d4c4c6124b1c14852c77920b88e1b93d93a4469a7f2"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # Remove incompatible pre-built binaries
    node_modules = libexec"libnode_modulesnetlify-clinode_modules"

    if OS.linux?
      (node_modules"@lmdblmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules"@msgpackr-extractmsgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules"clipboardyfallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
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
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}netlify status")
  end
end