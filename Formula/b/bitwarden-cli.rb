class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https:bitwarden.com"
  url "https:github.combitwardenclientsarchiverefstagscli-v2024.8.2.tar.gz"
  sha256 "210b40f54de79f4ac3d20419fc58b0e7ff6cebe5f3c107c68d0d2e6b8b073cd2"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sonoma:   "4c5a0045ba46b89ac3858b6bfe77e8cecdb9d6ea6c845ff93df55682167a34cf"
    sha256                               arm64_ventura:  "46ace386d5b8a179a47165f09ffe21e16a0cde2b2bedc92503ea843c7836c74e"
    sha256                               arm64_monterey: "29456cf833df0a6760bc14fdef3a918cb53d357ef0bbbfb70486004cc4e11a43"
    sha256                               sonoma:         "37a2c651312845a653f028fd33ee6140b6aca75835a2c6c952bb68bfed87e11e"
    sha256                               ventura:        "be9b3414c20bde9c0f8dd05863404058fc2cd59428ff16e1201f5e29aae6a282"
    sha256                               monterey:       "e9a2989cf7b380fbd8f402ede056a8431e2320f366c0f852c19f28c2b429d1a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8943aaca2933117a28af11f0227fb3f5415d50d439855c461b40ea560c809dc3"
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