class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-21.1.11.tgz"
  sha256 "ff288f10cfb0c63d1e9d6806f33c23d6ac7380b053446d391d78d9776ba73afe"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "9668661e8c6b237bbe1b972dbc9b6b52f0bbd20b90e7087048293119717f6a5a"
    sha256                               arm64_sonoma:  "0c05b50c8f05e5b4c176a6dbdbfee51777056dc4c1b7b5457dfd57e0c4efb2a4"
    sha256                               arm64_ventura: "46426a67847423b5dba17b2a7df4ab89afb5a16e4cc3e541426dbec4f4249f1c"
    sha256                               sonoma:        "d55319ef9e86deeea97c58c99544fcbc19e00979e4014a06de4c3c7a13cb1eac"
    sha256                               ventura:       "ae7149d58471aab4f68daf7429b8cfd0df0e91cb9bb2baf0765f883e8295f8d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab2fdbf6c3d3d1c7df0deb30cf9880936c2d19abbc68faaaa4553e32890dc446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a45cdb268b771a7d751cb4c0b0f38311dd5ed2b5266f256159715d41c82d0ed"
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