class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https:bitwarden.com"
  url "https:github.combitwardenclientsarchiverefstagscli-v2025.6.0.tar.gz"
  sha256 "18c91d3ce09f0b722a3bc6b7a470b40823301973cd80e5a8bc54542541075020"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "de62380d78e2f00b085374ff4e970c0335192a1c45db378a54105d8fefc3d8c9"
    sha256                               arm64_sonoma:  "77bc30cf0c3c24ef8a8c1b973fec56d5f919a35ae6b77ca8c924a32c7f5feb72"
    sha256                               arm64_ventura: "e987def1d068cd11fcaed6bdb7f0c463db999eaa84cd256385af9b18003e055b"
    sha256                               sonoma:        "b056cfc386753679435a46b2d43ad6fe9d49c9bd2339de8e4f37e806b502ff5b"
    sha256                               ventura:       "e914b0719c265f584376c91ff741fb0bea4cf0323b413b2dbf3ec17544d701bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7fec5040a91ec8de779d8f389cfcc3347094172d8a997d3629fe6f26bb0d550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b038880ce2820eceefbe3c20cea8e6b6aad962f63fb3b7d4d9a7265045377f4"
  end

  depends_on "node"

  def install
    system "npm", "ci", "--ignore-scripts"

    # Fix to build error with xcode 16.3 for `argon2`
    # Issue ref:
    # - https:github.combitwardenclientsissues15000
    # - https:github.comranisaltnode-argon2issues448
    inreplace "package.json", '"argon2": "0.41.1"', '"argon2": "0.43.0"'
    inreplace "appsclipackage.json", '"argon2": "0.41.1"', '"argon2": "0.43.0"'

    # Fix to Error: Cannot find module 'semver'
    # PR ref: https:github.combitwardenclientspull15005
    system "npm", "install", "semver", "argon2", *std_npm_args

    cd buildpath"appscli" do
      # The `oss` build of Bitwarden is a GPL backed build
      system "npm", "run", "build:oss:prod", "--ignore-scripts"
      cd ".build" do
        # Fix to Error: Cannot find module 'semver'
        # PR ref: https:github.combitwardenclientspull15005
        system "npm", "install", "semver", "argon2", *std_npm_args
        bin.install_symlink Dir[libexec"bin*"]
      end
    end

    # Remove incompatible pre-built `argon2` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    base = (libexec"libnode_modules")

    universals = "{@microsoftsignalrnode_modulesutf-8-validate,bufferutil,utf-8-validate}"
    universal_archs = "{darwin-x64+arm64,linux-x64}"
    base.glob("@bitwardenclientsnode_modules#{universals}prebuilds#{universal_archs}*.node").each(&:unlink)

    prebuilds = "{,@bitwardenclinode_modules,@bitwardenclientsnode_modules}"
    base.glob("#{prebuilds}argon2prebuilds") do |path|
      path.glob("***.node").each(&:unlink)
      path.children.each { |dir| rm_r(dir) if dir.directory? && dir.basename.to_s != "#{os}-#{arch}" }
    end

    generate_completions_from_executable(bin"bw", "completion", shells: [:zsh], shell_parameter_format: :arg)
  end

  test do
    assert_equal 10, shell_output("#{bin}bw generate --length 10").chomp.length

    output = pipe_output("#{bin}bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end