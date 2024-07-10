class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.38.1.tar.gz"
  sha256 "620eb35903ccfff210bd03493dbeb862caf78757e307918ea83d4b3ea7085ce0"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "396e05e1e3308e83bcb41a17cda11adb64c6d6e3c8c4f14828beeec75250930a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e37a4db54fe9ed4e45d47b73031408d947f43cd93603f74141455a10f5599f53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c03a8b44d9c4077d8fa0482b6576c44d23505aa07df6fcf5bbc295975584603c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ffd722f62a90cf625eade441235253dd90c6d817d029eef37184db653a13f20"
    sha256 cellar: :any_skip_relocation, ventura:        "4bdba495f769ccf7202110ed8e9f50df4710b4ad68908a1d4087d8e23ed71239"
    sha256 cellar: :any_skip_relocation, monterey:       "a37abd8d4e70835ecff32e8066923464176c043f681dc4c4148dc13a06067a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4b773629d41c2113f0a118e62ae896547cc3e540862869d7e7a4f008a3cbd55"
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