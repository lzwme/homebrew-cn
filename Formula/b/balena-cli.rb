class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.1.4.tgz"
  sha256 "52ef56c1072e3720f9ef18a78f4c0755caf84b8b06a628d096efe2f2645afc30"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "4fe1e69b51e0ce308f258c22c27534214bcb064daecee222b6d76279fcf6f8f0"
    sha256                               arm64_sonoma:  "1919c612ae7da0a268465ce17c373b9552b35403556a5c67629a495314103bda"
    sha256                               arm64_ventura: "d65298ce0d9c4b8434994104d97576deacdfeb017214b2c524183833334eccbe"
    sha256                               sonoma:        "fb06a9947ac514e5986ef00c87398fbc34444cb5ff6b2f39b0bbd21923f19c10"
    sha256                               ventura:       "f085a60e450dc695472808c6aa09c3a8a6bad86ef3f0fcd56bc14e8b9e2eb74c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fadb1401e80c98fa109100e3df371bd7a34f66de2da8dc603218a382470c1aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebb40e8eb25945e191ac49117188168ef9bbaf4f3d281d0b6125f0f9169d1f8c"
  end

  # need node@20, and also align with upstream, https://github.com/balena-io/balena-cli/blob/master/.github/actions/publish/action.yml#L21
  depends_on "node@20"

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
    node_modules.glob("{ffi-napi,ref-napi}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

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