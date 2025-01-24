class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https:bitwarden.com"
  url "https:github.combitwardenclientsarchiverefstagscli-v2025.1.1.tar.gz"
  sha256 "6159a3028156b1dbbfcc044631b1426b3bffc28f8cc4aea077199fb95551ac42"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "b50eb49b4e5a398d92b0acd6dcb0f8dfb2429bab731e46c7ec3ecc37f4bae859"
    sha256                               arm64_sonoma:  "7ea7d57b5f9655c8484ab4fdd62dabaa197747d86b8fefdaa6266093b8c213bb"
    sha256                               arm64_ventura: "132caf43bd08cd2d8c03d808575a72feb064fbfcc2d32970931b46890241e431"
    sha256                               sonoma:        "7d94d1484c0c867b3aac93504dc636a4bf9aa738ed89d72a047463d8eb39717c"
    sha256                               ventura:       "169dc0dbb68a5ab97496d43c38ce9ded5158a0045b0b9de5fc8d6a3d4e918905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd0f447f9bed565562acb172ed2c44038a91ba0461d429fab652c69263d249e8"
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