class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:www.balena.iodocsreferencecli"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-19.0.11.tgz"
  sha256 "0a89c0a50f9746b3dfc045314ea9a24043b2962e2f319cc5b109284753f60291"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "f46cd33d5d60b2b2118ba9cd6ff9828a79855b5c495bdcd1f41d212122b93e6f"
    sha256                               arm64_sonoma:  "638acc37d4b1d6cb0f0c8068e212ae01bde04c70459a531ccdfd9abf0aaffcea"
    sha256                               arm64_ventura: "2d88650cd9c7bed942cde4c4cb059eaae90637d24ad57721dbfa89f2384a7ee0"
    sha256                               sonoma:        "afbab4f16981b49656b725018a736fc862b7ea913cb640f86dbb45ad0cdff3ef"
    sha256                               ventura:       "1e50003d0847ffe76402bae8f23eae0e43103021fae411e9455d4e2c1a354cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4498f1a16a6e4b50ff0f19f7967c9cfc1f5002324be5d5f9751826528da5fde"
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