class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.35.3.tar.gz"
  sha256 "090b1ed0e500838dae502b00bf7a9e9b108cd2271d3f76fb39f5d3b123a9ce14"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7666f767d513f043a85abf7e3888b3727a1a60b66b23e8b12b99a432177fead"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a2695584ad5ce49319f5ffbd73d7438ca81651541b2c889c2d4290eb3ca62c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "344ac5110c89332948459333eab6b7eeb76129c564298849da6879ae69c09e96"
    sha256 cellar: :any_skip_relocation, sonoma:         "a580997198082a847794d07cfbc6048b812479d54abe62b6e1387153541e8089"
    sha256 cellar: :any_skip_relocation, ventura:        "493f7322bcd12e6582b8f7ce05b28d407f53135f9255aa93c2d748f0c8ec0f6a"
    sha256 cellar: :any_skip_relocation, monterey:       "52d821d9b52f49ad0b8208424e93fac25952a0c99853f33ec7ff092ef8fd4975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1820cae2e61a558f56a1445e95f48554ab892ae7018a4c9a61561b44cf6ad34"
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