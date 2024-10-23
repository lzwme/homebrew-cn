class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https:bitwarden.com"
  url "https:github.combitwardenclientsarchiverefstagscli-v2024.10.0.tar.gz"
  sha256 "1396b949f482f398bca4f59a4a7e0c2d9549f9b461bf6af5a9db04dd9b6bcb64"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "73e7bdccf0453ac4bbc1f95bfe6e6ee474f75f1582b82cd10dd2747d92c0b529"
    sha256                               arm64_sonoma:  "325dcafb82e8eb23bfecde70ddf00b6c571352afb5ecc1a745c1412e3e170e21"
    sha256                               arm64_ventura: "a9b8783ab289d58d0fd6ad59600e1111fa835615e5e3a71c0b68a46b823e2cb3"
    sha256                               sonoma:        "cc9639064cbc26be1346bbcf58f2bfe357cea4a36b4afce8d032d9a679eabb09"
    sha256                               ventura:       "7f73b6b16e524414c4fad0d86dbaedeb0d37546aeb18fd1b01bf70480d180f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8f2196b98caa890d5db72683c335d684fb4981cd7a6ba450cb172cd42f57a77"
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