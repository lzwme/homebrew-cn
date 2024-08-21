class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.40.1.tar.gz"
  sha256 "989b10a5159cb905efecd737dcd193078b454f9d86e6ef47423d1c90bf14933c"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22296dd201f9969fe8ee39fdd4a53383f83ff9569c363ef0bb42bc489c38f125"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f1afd9553c1de8c3bf59b7b0b7ce3cdaa86d5823e796ef207908d32ad456001"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55eb4a3c6913b900e8674efdec5f36a65a110565bd929e2f0615c8e275548d57"
    sha256 cellar: :any_skip_relocation, sonoma:         "d02be2cdd08d564b4d9e4f4df73e3c6026dee08b89b384879ea05223138b814e"
    sha256 cellar: :any_skip_relocation, ventura:        "a7d19ff47612bbfa05cde651d3be5e7ff6afe73b0337efc78518ed9ff9eb8c4a"
    sha256 cellar: :any_skip_relocation, monterey:       "22451d7b562be31679b8152bd0b4b3b0d5e446fe2b3c2b0ba084e55a66ec98f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a253dcee73a2ee4db01eea9f586dbc6a793c07942e9658a7ca8d9f3393e8dc14"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

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