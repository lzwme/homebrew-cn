class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https:bitwarden.com"
  url "https:github.combitwardenclientsarchiverefstagscli-v2025.5.0.tar.gz"
  sha256 "247ca881c8a9f407c494977f7e8555fe11beff017d0cfda6a6d437ec0c0978d6"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(^cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sequoia: "97764f18ccb72f733e498c9feae0868cce7013f4b44b3553b9dcf07aa300aed0"
    sha256                               arm64_sonoma:  "5453236d390febec8928d0eb0509c6670d26cfed1b688d1a0a8836594a4dcffe"
    sha256                               arm64_ventura: "1b0cda4216b9f50fd0abec50a11c9a5057f40920b41071ddaa45d3326db12bca"
    sha256                               sonoma:        "7e9ea72690b0f9418549c0cfc80f313f78eaf8e2504bcd0d6cbaba1c1a60edce"
    sha256                               ventura:       "0722698c9fdfaf418aa785fc052953dd3376e079fa5982dc24542808091f3a88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eee38d6342ccc2210db45f39429bee9f26e01f06ab8b23b625743930c601446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b301cba25a0f398367dd0cf84de63153d465dcbb53c57475764abf3aec790d52"
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