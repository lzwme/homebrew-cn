class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https:docs.balena.ioreferencebalena-clilatest"
  url "https:registry.npmjs.orgbalena-cli-balena-cli-20.0.8.tgz"
  sha256 "18743c1fd164b065c10cb1c003d0539965f351de6352f258eb4b60463dc5ca69"
  license "Apache-2.0"

  livecheck do
    url "https:registry.npmjs.orgbalena-clilatest"
    regex(["']version["']:\s*?["']([^"']+)["']i)
  end

  bottle do
    sha256                               arm64_sequoia: "f38013580fcda3de9fbb0cbe6939ac55ab80763de23eb64df30dbae3c11c37b2"
    sha256                               arm64_sonoma:  "c31ae0664609ac00a2e3f24396e9dfd950ba3268fe0b8e15e354253c0cc4688f"
    sha256                               arm64_ventura: "57ac5870c53ce406b488891c16475b80d06a585b23549ebbcbb896fd7550f099"
    sha256                               sonoma:        "4f78d1d604fa71d47b255ca806fa5c8639f0c40d425a77b0e90681da10d63a69"
    sha256                               ventura:       "5cefa5b0e48120d6aeed342aa6145b20e1dc97db018b02dbf76714974fb7c3f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f215a47aca58c1c43890d45fd3f155358b10753c55cdb0863fcdb6f6b49c1402"
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