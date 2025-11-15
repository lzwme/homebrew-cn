class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.5.5.tgz"
  sha256 "5fb777c34e11060b198bac5700b26cbedd27e83a56f7e8a76445a647ce3408d8"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "5c6b116c31b4bed49d2891410a34322dc1e144ed570881287d2701194d91ee01"
    sha256                               arm64_sequoia: "9e8ba2b51dc102dab3d09220194c93a4872f12bdf17be39ecc643655fd7cbcfc"
    sha256                               arm64_sonoma:  "210926e3c6009bd011ede9a7b1582af260488416bbef7087d80803713e6cad4d"
    sha256                               sonoma:        "7d1d267f36cfb85b080a8cee1436d9b1c60d609ce755d0df6f901859f2209e14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "284f27be5787aba649152e71502437aaad509e5cd8a595f121c41a4d7ab97357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb8af7a316059b6ba08a5ba8dd3eae186ef5cd291d156517c4668b340295fdf2"
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