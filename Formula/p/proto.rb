class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.36.0.tar.gz"
  sha256 "1df4e1d7875f1acd0f0fa15a387f1f1fe673c8e4dfca32d3c49c711a692d918d"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8703ecbb6d2a4cb9bd33708adb8494942ef1c06135041f6d867b5b72a2ac4a50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0301efb8cdc290e38c3f723b3b0527eafa24baad4d97a1bdb3bd83ff761b7df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5c921cce9aaaeba7cae23546249393b2c80933046864bd5cba215dc344ebac1"
    sha256 cellar: :any_skip_relocation, sonoma:         "42ef71a9b9f4f0afc9ff6deaf77b6dffee5905a2b96da8aee60c31f5c1de29f5"
    sha256 cellar: :any_skip_relocation, ventura:        "5fd52d81f631a09ec648f5fe491bbea3d5cb704f738600f99e63bcb6d8623c38"
    sha256 cellar: :any_skip_relocation, monterey:       "a5bd4b5400b658b6d28e35c8b79e56a51b957055de4db94be8abcc415affaf65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00654748aa0d805e4c2b132137ca330a5a701804b10e313d3a9555be99ef45ed"
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