class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.60.1.tar.gz"
  sha256 "46c5231728ad5b8491429dd8689d8f16f12910090a2b64ea4fa433054442790d"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75f21e682426ac8c4e4fa1196f68c4178adec700804e2e788873fc18a5882550"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37fe72671f4703377af837c6535d012989d9dd874c7803cc28309724783a837a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf9ee0ff654d00875b25e6aa45d94a4817de2ac490abc68a1df91e7be1f27abc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bdced233a9e2fb71a6e271194c3e78f043e3173ec03385efff48126b8ba4cc3"
    sha256 cellar: :any,                 arm64_linux:   "401bc5c4f2833dadbfb8f092adff3ba30aa806da4f008e6459f4486d0adb042a"
    sha256 cellar: :any,                 x86_64_linux:  "d199d894261a0ddf0f6177693405bea2ae19231255d7623a04afe5ec5df55e46"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    node_version = "24.15.0"
    system bin/"proto", "install", "node", node_version
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match node_version, shell_output("#{node} --version")

    (testpath/"test.js").write <<~JS
      console.log('hello');
    JS
    assert_equal "hello", shell_output("#{node} #{testpath}/test.js").chomp
  end
end