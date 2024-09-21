class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.0.12.tgz"
  sha256 "429ed6ab5ed82512e03dc3a65e0e1d2045f01f28f4c183e5e8c0027a58887390"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "6a84c6e9ea4f7b241a5e393f2aa86bca7bf269cfa10ddb1b6d58db78a55996b0"
    sha256                               arm64_sonoma:  "e21bff11136a67ecc7f742e64ba7333fa6b05b7b0420c82f04bae32ad7b42daf"
    sha256                               arm64_ventura: "7746dd4dc2c54c321052f9302fdaed9a485077f9d15b22009561423538ff65e4"
    sha256                               sonoma:        "926561dd40fad34ec9d8ca1f4a9ee9d5db7eb331fd0cd604de62e64ad50ebd88"
    sha256                               ventura:       "6e0dc0aeac314d1ddfcdf180d4ca3797f41f3ef1476660c862fbf9207e903c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0908a42c27bfdcd99ad5454c240a361a7b92bbf3d7eba73cc0f6b08f60a76899"
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