class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.1.5.tgz"
  sha256 "6121c7445af67c9a9827c5c618d3bcd9aad2118f8c0561b41c8513dd7aace9ff"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "9bfafb7342f0744f317d020b44fb640b3d628a76226a69807f3703b4cb872bdd"
    sha256                               arm64_sonoma:  "7a6061c124b48c83650f89837a339c07a34dca738bd759758a52893862384322"
    sha256                               arm64_ventura: "b0ea2f60fde3527b3cda5d1c4a300072e9be6ee57c30c91cbdfb0ae94dd6ff4e"
    sha256                               sonoma:        "eb0b26805fb8f3c43a779308cdf3672409680b005725e5226a785380620c3166"
    sha256                               ventura:       "5238ca57bebb6f10d44da2bc676a39bc14dee51bab732f3f77493ca9dced3463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf9c86f238413f03ffaf2473d6f73b253fe9feb4594be18c88fd3eaee038b0e"
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