class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-22.0.2.tgz"
  sha256 "8568d0c488ee886dbcf7db25e59fc9a8ec4149763d95e293a44dc409e795353f"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "7fde298c26a10fc482d0ab484ecbd1c85265661bc7696362af4a8af89d8e2e39"
    sha256                               arm64_sonoma:  "edb6a7895ae83814bf6aa1b0c4e608ee7134d706f96091f7c4125e0415f214ed"
    sha256                               arm64_ventura: "d5725eea46da1d96bf25c024f18f2b6adc0a4097f1e1a12f4aae504ea2c36142"
    sha256                               sonoma:        "081269ff06101c8f8ee0abd556c3ea50600a3d56dc7603de2d725ec46d3b7383"
    sha256                               ventura:       "d6b5c35a31d308e897c3d991695f52e3afd4d1a457df1c2c73e6eb9349da566d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38d8f1ef81d074f64a8b825c6586b58d0e1d6cbe0dc2abbe3ba6eebefe0be446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb44cca086e1e514e5d17fc1990acda8dea67c645dec3900e9a072c5e1b9a036"
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