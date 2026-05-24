class BalenaCli < Formula
  desc "Command-line tool for interacting with the balenaCloud and balena API"
  homepage "https://docs.balena.io/reference/balena-cli/latest/"
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-25.1.6.tgz"
  sha256 "1f526868af152797136a680d76096ad3e48f0dac6e45411b0c5cc426ffcede47"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://registry.npmjs.org/balena-cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d6635cf90d54d1ba5121ed57cf58e26efe5f2dac9977c8828b2786ab126ce99"
    sha256 cellar: :any,                 arm64_sequoia: "b713cac8902d75c79540cc080daf7707074324c1b5ddee947fef57df8afc8b23"
    sha256 cellar: :any,                 arm64_sonoma:  "b713cac8902d75c79540cc080daf7707074324c1b5ddee947fef57df8afc8b23"
    sha256 cellar: :any,                 sonoma:        "1df8b9e69593b5914500d8c544f37d0696c7d247120e8d5956868f96f848231f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd33ee3a1ec476a745ce81e783d8db9c6015f83990f1e4987ff077e3e4484269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a9e96d461f657a2d010d74fe188676f7b6836a6756feaf98c3fe678636caa7"
  end

  depends_on "go" => :build
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

    # Build dependency @balena/compose-parser from vendored Go source
    compose_parser = libexec/"lib/node_modules/balena-cli/node_modules/@balena/compose-parser"
    cd compose_parser do
      ENV["CGO_ENABLED"] = "0"
      system "go", "build", "-C", "lib", *std_go_args(output: "../bin/balena-compose-parser")
    end

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