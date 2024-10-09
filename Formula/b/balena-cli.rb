class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.0.18.tgz"
  sha256 "065bd0747df958d1da3172d634d1f35b7940b9c77938b6927e85c33cf0ce66ca"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "67f612248e59c144679203b02d210425a85fe09aa05ab8c73f41dc9c972a380e"
    sha256                               arm64_sonoma:  "94b6a412bb1382dd2ea9a33dbac2ae6f3879b022d7078d9ec141c692c45e5746"
    sha256                               arm64_ventura: "4a9558ea160d29aed3085414d6ecd3507995a7e5c937e4cd0cb6e4abeb4b3b64"
    sha256                               sonoma:        "3f9b983bb1f798b70d054fbaae636fa9e925b878f4ecbb8779362e56fc8c3c62"
    sha256                               ventura:       "11535f15b14e3312ecdb9109d07b11ae65697c9a1a6025a603c81ab807619cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55c3584f0fed3d3a6f49918a9d5e12814a0a3d667345478fd1e4fe391fd6077d"
  end

  # need node@20, and also align with upstream, https:github.combalena-iobalena-cliblobmaster.githubactionspublishaction.yml#L21
  depends_on "node@20"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modulesbalena-clinode_modules"
    node_modules.glob("{ffi-napi,ref-napi}prebuilds*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules"lzma-nativebuild")
    rm_r(node_modules"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}balena login --credentials --email johndoe@gmail.com --password secret 2>devnull", 1)
  end
end