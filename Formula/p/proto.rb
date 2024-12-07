class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.43.1.tar.gz"
  sha256 "6ceec413cd2df8d0eda7f5febcca8bd1f3bf6150b7f85832e77331fc668c5682"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df506b5900f05fb31c1d14ea21a202f43adb5e9c2a2a938b4ec9952b689aefcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90c47fbf34503db88f4b5c3bf2d4d09f2bf79b040947faba3fe33c355ce7c93d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01f3b9318bf2ead4554514af9f15e2b3a3a3e52ca464deb441fc9683300ce77a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7e8db8b8d0a371e75bd26dbf392367e69f6e460d61eefffb04254e56d0123dd"
    sha256 cellar: :any_skip_relocation, ventura:       "bf31d898c0b9ed5701f2fc9e005e4c5cdacbc8af704479ab9d761f27173c6283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14aff384bfe9f91f719049ad83776728913f68fafaf9f4f47b1f4b117308b01c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (binbasename).write_env_script libexec"bin"basename, PROTO_LOOKUP_DIR: opt_prefix"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}.protoshimsnode #{path}").strip
    assert_equal "hello", output
  end
end