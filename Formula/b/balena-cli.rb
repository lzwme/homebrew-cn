class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.1.1.tgz"
  sha256 "c17ac45b012cb6b3ebe032bd5318da473997e57fc2374e8d91c674f7668f0ace"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "55ad0ff2a7a417670d81dea84901d291de320f7146b2e94a9722d156d07bab46"
    sha256                               arm64_sonoma:  "e776b2e02d89c67194f03439802dc8ed658c84281bbb6ccd25ddeda950af52de"
    sha256                               arm64_ventura: "f395a2a57aec962cbf6e8b5abccf94348787feee51dc258de72def89baef3c72"
    sha256                               sonoma:        "7b7933f90ef1c3cc9caf242e05e446b9532d0e982fe9a259d83439c34ba37412"
    sha256                               ventura:       "af97d25e2eabb3bd89ceee314839ceb8454ad0cedf802071bf87c9c3f84ad892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5bd4939436cad23909fcf433017f25b9bbb210037198c405af549392e7d3c8b"
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