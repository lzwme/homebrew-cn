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
    rebuild 1
    sha256                               arm64_sequoia: "7301888778a93e4807475350b1a001d4e6cc80d1d56d94153d250d01ad667252"
    sha256                               arm64_sonoma:  "5b918f77e9185ada288332d2381681bfedc5c789c0848ec065301682d58c88a0"
    sha256                               arm64_ventura: "4c4edb366f65ae20e07f3be32915c30c1d30f779e0d4da95c015c2b554e98122"
    sha256                               sonoma:        "9aa23e06f199947d7639b8ebb9163dcd38702bc0f98b213e081e5de125fb0de6"
    sha256                               ventura:       "f9a6fd88f57b5d77d4c4d3080e561e807c97b170491beae85e20f218d5d0d64e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce1a51de4b97580ed639a95080d6ea64578f69d50412890831f0465a93f4a882"
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