class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.42.0.tar.gz"
  sha256 "7deca1a5161e63de954cf1f79b160e9f2cad2a5961f15f9f94b4091fbcda8954"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a485ab6cd1f1a648ab87b598cb3d27233ddb99db372958635fc84165becf668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fe3fa94f372d029941c69f16a8fb8010cb4ba2632f5a0ad3aa03c99db12f933"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "663a6817db5ea29ff6421e8ac906f0a004969ca4e049667ba43e89281836b5b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc13e314d47c787e9e23de301a703b4f65dd8430372d5c681fc5974eeb369aad"
    sha256 cellar: :any_skip_relocation, ventura:       "75b7d1362346828891c03c08b653a1c33bfaa58c19e4d0413e9a67c0f9d66137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e903eb04a075cbbf32e0179cc7bf5a4519f2661c460eebdb3c02bf366040a7ea"
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