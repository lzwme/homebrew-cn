class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.41.4.tar.gz"
  sha256 "86e8df7e56ab0a194e8e1b2c9f9a26dcdc3ac49a8e0964a4691062fa3157920f"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0725e3d3b0d20ed7bddf3bd8e493a088f6af8965c2c157877ee32c46e61c7e34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bed0e6ae102dba6ccbaf18ebc75e6a2c0a97ccb2fed96648ca620ed2eccdb22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "949ae75a25231fb52920708cee487f860f353d12efdb9340ede5928537f2809f"
    sha256 cellar: :any_skip_relocation, sonoma:        "56dc0ffd535e15a0fe9f510e69c80827bbc2614d63cd1dc90f3569b103574aaa"
    sha256 cellar: :any_skip_relocation, ventura:       "f3bbbc8f916a525b39ad4489c87ac5f6d178cf21e4e558f1edd531623e103b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb3bc793502a09d0fcba5c602f0a51932b9640923f201b8f95cc4f29f52e35d9"
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