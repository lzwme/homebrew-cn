class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.2.10.tgz"
  sha256 "fc01322b2ec3d3a8c08ca8314bab5d932fabfc206ea509dd5f2c8f5c07be8bd3"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "b64dd8ef6bc321387bdb15a4cf0fdc29a9c4eb65c03387e054cccaf11d31bc97"
    sha256                               arm64_sonoma:  "d2bc3ceb3a0ad5c815a2ba4a9682d8d13bc37cc4a2b69bf6b917c720ed45961c"
    sha256                               arm64_ventura: "e42ba67b55f1aeac1ad0d1fd6f4698c1b28c9a2f30761e454108a7533eac2875"
    sha256                               sonoma:        "141d83de04f78cdb9cf41ebf9f568be4a9f511e7e1d9392d8269fff9b6ed4203"
    sha256                               ventura:       "e8767816e581217608e87cad2042e5ff0648640856afb064886d787ebbe1a022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "677c26bde2d5bb3830a6fa804372f67caf3e904fc873c83e3f705744d89cb927"
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