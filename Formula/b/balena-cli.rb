class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.0.2.tgz"
  sha256 "49548dbf4edec9aa33da12f93d073445b2dee50af18500c2684efcdc835c72ba"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "026b248af0c0764e1688153c890f97a4f886789763f69fb0123268b077feaf15"
    sha256                               arm64_sonoma:  "33e6b361935feef602d3166c5b1c99c9b540d9c5cfce066246abed9eac19c756"
    sha256                               arm64_ventura: "771b9f116501c86194732d84a65eb3c9528e81da247d72499cf363ae285c3423"
    sha256                               sonoma:        "0e997b3228da4ffe36645ef358b4c7f89b6ec94737f361ba1aecf1cd860777db"
    sha256                               ventura:       "0596b11b6ae2e8766ddec7de8ca9f6fc95a33a64ca96698ed6234fa201a5daad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9daec20534ab76f406aabd539a0c92939ae53b800fe4f058a260de505a703bd"
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