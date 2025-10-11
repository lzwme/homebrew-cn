class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.11.tgz"
  sha256 "db26c96d2fcae96b3ab983e21c28079eb10dd9e967fe4763942979b881abf416"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "7092dd98dec6faa8c697fc176a4a44022ae8f4ed8600f617d1f426bf5483e807"
    sha256                               arm64_sequoia: "5616aa540ab52d6d22ce752954e871515ef23ece62617f8816d7bd30a172cc89"
    sha256                               arm64_sonoma:  "2e8464fefe8bd83cc73549f9ce6fc136a6b599546c6aa41f06c562ebfe1080a4"
    sha256                               sonoma:        "cb88f4da7e664d75b68e08f558aaa8c8b58f509fb239efcc2ccb975b00f39fba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5898b1216dde1af11595cbf0a11f7061934cacb7cc8c6de9150558e034ab00e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64baa102be03fc75fce7c4306ee05583aec44d060bd0430489356432023e7595"
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