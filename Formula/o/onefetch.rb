class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://ghfast.top/https://github.com/o2sh/onefetch/archive/refs/tags/3.0.0.tar.gz"
  sha256 "2877f2473120b41a33d03cc09bcded9ff4280951dfe447c1709df45b029e6e8b"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d248b0f70a54e8bafb4260c90fcf4c68e36aa591911099b49ac7381bdf5ba192"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d4025af82f3f4ae693086d5ca2889b2bb622ea13cc219f5e734b408b031d3f6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c385a86764bed65301cd60625e146c3b9aacf8ee7da31078d29bbed9f6250f2f"
    sha256 cellar: :any,                 arm64_linux:       "12809d72d10cbdc845ade53d617b405dec7a4156db37b4839721e0bb67e9e4d2"
    sha256 cellar: :any,                 x86_64_linux:      "f1c27ff60135aad76204b49715af8fb3992eaa5e580b684352f8823511a5b28a"
  end

  # `cmake` is used to build `zlib`.
  # upstream issue, https://github.com/rust-lang/libz-sys/issues/147
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "zstd"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["ZSTD_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system bin/"onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"main.rb").write "puts 'Hello, world'\n"
    system "git", "add", "main.rb"
    system "git", "commit", "-m", "First commit"
    assert_match("Ruby (100.0 %)", shell_output(bin/"onefetch").chomp)
  end
end