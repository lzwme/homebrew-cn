class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.3.tgz"
  sha256 "0026a5cd9a596a850d7248ba5f679bff2b5441fd31fcfa929a7a3799e6b96588"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "23bc2742eff329e537d641d2311cf1f2e6001a2065ca0817b304a85a85990a5e"
    sha256                               arm64_sonoma:  "5eabfda7f2f75e78091a2b0e3c955f8a3a3a6c57a6c6a855f452dc167ec4bb2c"
    sha256                               arm64_ventura: "af34a9731cd661ddb3ee4836de08224515cd337fc737dbbc992da0a564b3cdfe"
    sha256                               sonoma:        "44cf9023f8a4d444f73a86653668bbea638e7a6e24f3996d660979058eca7e54"
    sha256                               ventura:       "fcf42ccfa7a955f0ae449c258794a2760a91acfb5d3815c325be8642144b3040"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb60188a5ab147d7400441c58f7140cf9658ddd24754fc5f4b1f6c3b16c61812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e0ec458896937874eb2f0d8078f38a9fdc9fb4aead6d768d463b9a52d3a9671"
  end

  # align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@22"

  on_linux do
    depends_on "libusb"
    depends_on "systemd" # for libudev
    depends_on "xz" # for liblzma
  end

  def install
    ENV.deparallelize

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{bcrypt,lzma-native,mountutils}/prebuilds/*")
                .each do |dir|
                  if dir.basename.to_s == "#{os}-#{arch}"
                    dir.glob("*.musl.node").each(&:unlink) if OS.linux?
                  else
                    rm_r(dir)
                  end
                end

    rm_r(node_modules/"lzma-native/build")
    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end