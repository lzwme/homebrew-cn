class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https:bitwarden.com"
  url "https:github.combitwardenclientsarchiverefstagscli-v2025.1.3.tar.gz"
  sha256 "4ca7ac116545c9f1de0d8c0f776ef21f10e472e10785e7ed1e3df64e4dd2545d"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "05defee18c99358facc3bc9c10a4a72a31a8c512aa9db9bf87f0b02855623da9"
    sha256                               arm64_sonoma:  "272cfc1de81eacb3044316005404d6b0d10f8b28b459558fc2c4704faa8bd3af"
    sha256                               arm64_ventura: "31007d79fbe018888d055b44569c33d49902534929b5a89d6f64f26cc832b956"
    sha256                               sonoma:        "faa20f0e8cdaa8ccce9e6b67dee053783cbb31de7921de7714dd5f06518ed0b7"
    sha256                               ventura:       "87f926b74605f030c44cea0cc0ac9afdbddd35b1e396a1c2bb31f5ae343fca23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc6b0dd2a775aa8062f67cb76e9ae082d647620ef7454e85990a34347b3e754"
  end

  depends_on "node"

  def install
    system "npm", "ci", "--ignore-scripts"

    cd buildpath"appscli" do
      # The `oss` build of Bitwarden is a GPL backed build
      system "npm", "run", "build:oss:prod", "--ignore-scripts"
      cd ".build" do
        system "npm", "install", *std_npm_args
        bin.install_symlink Dir[libexec"bin*"]
      end
    end

    # Remove incompatible pre-built `argon2` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec"libnode_modules@bitwardenclinode_modules"
    (node_modules"argon2prebuildslinux-arm64argon2.armv8.musl.node").unlink
    (node_modules"argon2prebuildslinux-x64argon2.musl.node").unlink
    (node_modules"argon2prebuilds").each_child { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    generate_completions_from_executable(bin"bw", "completion", shells: [:zsh], shell_parameter_format: :arg)
  end

  test do
    assert_equal 10, shell_output("#{bin}bw generate --length 10").chomp.length

    output = pipe_output("#{bin}bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end