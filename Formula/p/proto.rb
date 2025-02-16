class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.46.0.tar.gz"
  sha256 "cfc60cdb8acd7d29923f5837d4c7caa42867ed45f11515863f3a958bd6630e88"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "491dd176602a37b2e5f056939d06a76a8aaa6c0ed37b46d1d9ba163fc78dd771"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eba4bdc85d620b8a1e3839b1564f637fe032203bbc233bdb6b0302f7d37416c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f550d8783a55b8924adf9fb1500e48f23fe6f8f0c29a6c55fa0e11b142e5a9da"
    sha256 cellar: :any_skip_relocation, sonoma:        "050ea797fea0d125426fa5b32d50e683187d060440502ff3b26bbc48ae70b917"
    sha256 cellar: :any_skip_relocation, ventura:       "08fd74401865f18a2df125d3a2dc4df01ee66191bdc2082e00c9929d5bdd702c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e00cba416505f4ed424922b200381b2196ce885263d0e37c59ca14de1dd1f1"
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