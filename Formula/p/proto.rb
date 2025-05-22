class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.49.2.tar.gz"
  sha256 "a859417f36fbc5f6b2fa841f6d9b5c289254b5916e9068c1a3c1461c39827501"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd33bea0513fc3a045aa6e88b63025ade0331da3c3ccc03a4322819d35389d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2fbb2d17dff9108a5bd69427d5c739dc2f7a5dfdc78b3dec9e504cab7f462d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2bf71ae18825b70cf964cb132b83c0b0ce2ac32c023919ff7fdfac0592bed72"
    sha256 cellar: :any_skip_relocation, sonoma:        "761439fc9ea40f7ce8cd5ae2815fbb53ec508ae69e61f2761b00fc7abe1d110f"
    sha256 cellar: :any_skip_relocation, ventura:       "be16beabb13324dbd72eeb073f3bd1088bc3a8cfdeaa46ce18f15bbf13fba6e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ae61f2f9cd805b324b243db38568f5012092d27409e94607579f3407bd77169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d273f2559dc34b4bf99be919c67138eb078cba91e92c4201e5601893bb9998"
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