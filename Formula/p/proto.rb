class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.46.1.tar.gz"
  sha256 "eb5d10a1ca06067b0a03ec90ca54a3acd2b149b53f46286cb42df237abe04d3c"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff0df1bc5683c6e1bb9103747c572e4f4e556130c3e3371d14ca0400661f556b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbb9aa34b589206bea53de7bea85c2ae817e58738d6698d427efb06ee3dd6143"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18689dcff0133fb3712101df6d69afd694bbc7daa98b568e02e7975933546b80"
    sha256 cellar: :any_skip_relocation, sonoma:        "7740acdbe955db6845984754748aba5437bcdd97a10b03fa2f5b3c07eb071083"
    sha256 cellar: :any_skip_relocation, ventura:       "0aa1d1b29590a83ada617d34733d19680abead267ec5ae0e4f39684e86bd3792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c19c1667325cd3cd0ee9f4418a699e0c1c26a8cd3c57269fdbdb02972f30140"
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