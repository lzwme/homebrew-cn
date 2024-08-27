class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https:bitwarden.com"
  url "https:github.combitwardenclientsarchiverefstagscli-v2024.8.1.tar.gz"
  sha256 "73b3c7fbbc0eec52f9e3a237425d36234931a945f2249c7d77ee5219b9bfab05"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sonoma:   "4f82ad983029673cfea71a5ddcc7eb764c91f46350c324b3779e7f339595c4f4"
    sha256                               arm64_ventura:  "1a6e961c6ec89e623d883e38361d05951a4da2f687357359a9b8b6f4345ca5ef"
    sha256                               arm64_monterey: "88eb01c45b92d03d9d30a93a56b9109f37d963e9c912f22d646bb25f9ec791c4"
    sha256                               sonoma:         "a5b13647204ec13e9609976668b427bfb0e74f04e573d2290f07c5f5a3e69b48"
    sha256                               ventura:        "7da71f53b3ddd2986695164c42235caeacd7ca9c4f60ac65edce602430391452"
    sha256                               monterey:       "bd1572c39cab70da412b2c5eef16eff6fdd3172731c98044cdbf4dd91bc40d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41ed91157d52300297af2d7fe0a5c6bc51a44ae37c46d6749d516a562f67f61e"
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

    generate_completions_from_executable(
      bin"bw", "completion",
      base_name: "bw", shell_parameter_format: :arg, shells: [:zsh]
    )
  end

  test do
    assert_equal 10, shell_output("#{bin}bw generate --length 10").chomp.length

    output = pipe_output("#{bin}bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end