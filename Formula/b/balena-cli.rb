class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-22.3.0.tgz"
  sha256 "30383754e01635c5f244eaf87b2d721caec418b0b6e7eb41afd732a4fe0bf396"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256                               arm64_sequoia: "68c73e5a056dfe4e0cc6e6d00f2379dd25433d77eb78f5fe4f068c3ef6e6eb8b"
    sha256                               arm64_sonoma:  "9837e3e0314de0bd20cf6922cc1e75469c9752af7c47cc9fb8c9d757a267825c"
    sha256                               arm64_ventura: "ea37b3f27046af4a75807aa9eacfde1d5b5a9c3b211294a0d4c4478d1edeb68e"
    sha256                               sonoma:        "770c6262c8d3791de3f96249b1e995468c9de99da58fef6dbc4c40703ebc4957"
    sha256                               ventura:       "93b8dbc7256cf826a7614a7579cebe146e40bf64232faea4461768b7fab5ec52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2983581369a7d04e6acad0e1ac5275516b021ac113054a577a5cdd1efe14586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f3b27b5e114c35a619363b5aafa06c3902bd39ac087c39bb7e69138fd854424"
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