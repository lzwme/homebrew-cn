class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-24.1.2.tgz"
  sha256 "295ff5904e9b2772a2acab1076d0741273a8465491ae1a6e7ad282fe08339904"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ae8ab3b6ddbc35f80aaae100519b17917fabe4b03435d647bafb198b8328cd7"
    sha256 cellar: :any,                 arm64_sequoia: "155d5d5c7fbb8d602b6591964e98aef2c5eb8834f76029d4c80e0638fa3a8f34"
    sha256 cellar: :any,                 arm64_sonoma:  "155d5d5c7fbb8d602b6591964e98aef2c5eb8834f76029d4c80e0638fa3a8f34"
    sha256 cellar: :any,                 sonoma:        "8ab784cdffdf50c61c9c4bf81ffc8f9c35caaf4ba172bf57149de0f757083856"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e379232230f6645f6be5a8d5be6d8138953e8f8eee7ec0cf0a2d432aac41dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94d1c8321473068ec6f2755e7e712915d81798beb56f05f2d2b65385737a11c3"
  end

  depends_on "node"

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
    modules = %w[
      bare-fs
      bare-os
      bare-url
      bcrypt
      lzma-native
      mountutils
      xxhash-addon
    ]
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/balena-cli/node_modules"
    node_modules.glob("{#{modules.join(",")}}/prebuilds/*")
                .each do |dir|
                  if dir.basename.to_s == "#{os}-#{arch}"
                    dir.glob("*.musl.node").each(&:unlink) if OS.linux?
                  else
                    rm_r(dir)
                  end
                end

    rm_r(node_modules/"usb") if OS.linux?

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end