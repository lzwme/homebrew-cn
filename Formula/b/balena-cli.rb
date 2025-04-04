class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-21.1.8.tgz"
  sha256 "36efe3c52e8dce4bef98756234cfdd3c658f11a678844da75de46ea87e722aa6"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "dee0a8fce9e64d0cc45fcb09c89e3a9a19c1894efff4e987a7200bef2cbb807a"
    sha256                               arm64_sonoma:  "1f37816a21152d695371f1c1bcb1562dc090f40ab6f13156e95bfb92b62f6952"
    sha256                               arm64_ventura: "87921c0d7cbce7bd943bcb9c51e91a70aa13af7f41f8d89cd014f39fbacea8fb"
    sha256                               sonoma:        "782da4dcb7fc08816d78004ac6f3f3c6556c95b0d72166f65d57fa76829645ee"
    sha256                               ventura:       "8b64c6e2789086554f0b72d4391e0931b87b796a9d42b55bc9424a6ae585087e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e90593719c54036a432c67402d76a1c12ba349e8bf15c99723c60a742b4fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f527e9107df4deb2d4ccf06721d9f0fdd28b0a36bd78b4dc23074d86fef34c4f"
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