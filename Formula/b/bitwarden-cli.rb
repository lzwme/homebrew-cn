class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https:bitwarden.com"
  url "https:github.combitwardenclientsarchiverefstagscli-v2024.11.1.tar.gz"
  sha256 "97e51ccf3c5b5c4cfd3f02db4ea98604bc29515aa6401e0acfeb131334243cc7"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "1dee8afa822e26730ad228a324bc642ef84003516eeb3013b27b7ef66f19b163"
    sha256                               arm64_sonoma:  "25bf23ef506f160dd62ed802bee308b245b48a2a446f3a369724afaf891cd9ab"
    sha256                               arm64_ventura: "62bdb4dd9e382c657907add38750d0c0e845fce67f58ff9c5db0397eeaa70836"
    sha256                               sonoma:        "96737fde9a523b7d3e6478c8b328fd5588a0f5f2c117f2a318a1d6197667e8f4"
    sha256                               ventura:       "514e6638ccb27f246dc5c0b669f882f64b75938bc092333353c075ef9afeec02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5875b5ff6c41c51ec0bccba82eea63da92d912feeb4193520cc39a50d2b34db6"
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