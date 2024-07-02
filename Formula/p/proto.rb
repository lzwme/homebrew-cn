class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.37.2.tar.gz"
  sha256 "5dccb7c8840f9ebdee8f0b203149433a760f19e8835134b947198c61fec37783"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73571a855f65e70a5fdf640902ea4bc8c0a01929842f4e7e1248b275adbbb06e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73377e8144fc86b32190231fe0d2440158f9425ec562dc9cfc3817113864db80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66a8c0eecc0e61fd21765a1c7f0af57375a06e15eda6a0bce4e8563d7a1028ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ca83390b4855a13559ef470bc2905d90f38f0c362c1ec4b3b42c2503c403379"
    sha256 cellar: :any_skip_relocation, ventura:        "945cb5135a77e24ca0fea05e861ce52b3944a5651dbfd6eda7af0d8d1cea0581"
    sha256 cellar: :any_skip_relocation, monterey:       "68df0b26be223beb7c3ec15764b86dd40e212777144f178b61a72c6e188b948f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e837dcd40fff93cbb0afdb8b191d6e027c08a59e23b42d15a850849b1190eb93"
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