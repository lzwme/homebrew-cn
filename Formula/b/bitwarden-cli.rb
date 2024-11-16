class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https:bitwarden.com"
  url "https:github.combitwardenclientsarchiverefstagscli-v2024.11.0.tar.gz"
  sha256 "a55f2add020c51ebf2376c0a5f8fcdec2fd9c0164c61bc9162a778f1edd5f27c"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "8390437164839a4964681bbca8d7fc7b609721590543b52472c8fc1ce77f48f7"
    sha256                               arm64_sonoma:  "d21fe06e0476f3203d9bbd0d68a40265665b7c9a29a31886d4ce22e7480fd78a"
    sha256                               arm64_ventura: "60b55f9b140f21db10ba98739280be916bd46a3d249049d9b119a6a0a811805a"
    sha256                               sonoma:        "69c355971c6b4f217aac5a9c90b3f97b264faa2e767fd59120431868adf94547"
    sha256                               ventura:       "7bf6753e26f425be72f2da673558efd45ee5b0bc5e76da56339ac9cbcb12dd4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a084b9b6adb392d2c735bf2a1138f50d6bff5cb2e1353a2aae8619b0e853255c"
  end

  # fail to build with node v23 due to https:github.comnodejsnodeissues55826
  depends_on "node@22"

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