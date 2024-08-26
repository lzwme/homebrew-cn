class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https:bitwarden.com"
  url "https:github.combitwardenclientsarchiverefstagscli-v2024.8.0.tar.gz"
  sha256 "846e73763b19fafd4b1658911bcfa9638d68784cd287b24cf23d318c59ea04fc"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sonoma:   "19c58c0b6b96a9b04f591af52b2b778cac7520c3b634c60693c63681a7871ca9"
    sha256                               arm64_ventura:  "025818071d0075751680662372a365c2c304397df30140f820c406b8c7fc9189"
    sha256                               arm64_monterey: "7b537fc048b14d0408d3b68d3ee1c1eef32d04c1049a56a686969d942683301e"
    sha256                               sonoma:         "a883526cefc90d85a9252e09fb9c7dbf23c63762fe8ae79971258dffccefe75a"
    sha256                               ventura:        "53180b2adcd0f178067dc96812ed11fc2ef7df391b06a1338138dcc78cf87d0a"
    sha256                               monterey:       "d9d4e7c0c030519946b2453c42366cb716a1f493629ae981a98383a2dd5644d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0459b354ccda5ee871d78c16e066b74d93ea6d526900f0bbe843aa931bdf8a64"
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