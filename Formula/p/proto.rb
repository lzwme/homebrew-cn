class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.42.1.tar.gz"
  sha256 "ec1d37d1a9628fb443912e7740995cbf6670f7d443321e84559207b6f6053f4a"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b7ced29cb8a3957b904f75842cae657b6221ee1490fc12a0c8b3876abd5ade"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24deb1f43dbb951e32f9b8f8ce9afedd8de677281c60290a5a6674ba46ed22b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4895919d0db55947b260d33f42674016755cee0af403ca87423e7c74d0438448"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dfa4821de51b6c1520c0ce9b44fffb50e16b160c6ed9c7fb78c7c1755f97329"
    sha256 cellar: :any_skip_relocation, ventura:       "ebf16fdb2a90562d8030ce13bf643b83374d36579aef5c843b4cedaf2ca18a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe41bb11a2dffe862abbe03dfc5d5dfbc660d3e035af7b68868e0b936009220d"
  end

  depends_on "pkg-config" => :build
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