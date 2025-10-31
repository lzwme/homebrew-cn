class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.4.16.tgz"
  sha256 "f8b90fb573fc703c0c75afea651538468e2edf4f079616591e6439f0ed4ac36a"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "1d16f271c210eaf0ad8523c00f0122768b56e83323c31c5993113bb415e7f363"
    sha256                               arm64_sequoia: "762351dda4f43909dce4c0fe6769127b18a177185540d539542931c1b6463cf1"
    sha256                               arm64_sonoma:  "28117933383b88cdd52193992513d780f90cf0aa88bf508e3162d9177954ef5a"
    sha256                               sonoma:        "e7a8f70df1b28960c7b3409738ce8a4fa75a80943b7119fde4ebcdab957922cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bc2a9ae6a96a6ab84412312bc04ae335879aecccde317fafc92978b1ad2f257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bf0445164495b2a285830b4a3f3bc954c8aaae359ec5ffddf21df7c3b756fa2"
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