class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "1342a4f1daf6709dffd768423a556ccb59eabdfcb710a80270234f114b13b3a2"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f823a44619ea959981f6ab1570abfbc84676e4f29e481d413b41041f8ef4c694"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1b7f3d075108295cb82ddaa34dee6551ebcab983c57878806e8417e056870a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c533f279d64355bc9637c64006f6cd7cc6b8a55c9a5429331262e78c8fab7ee9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2eb2dfdc6148ccd07cac3683b858d00c6804e708bd6c175cb650f37c0611547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a0f400ef15ccf73509a17df18a1c921342378e9025cafbdac9023c5bf6300f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89c22c16a52c8edd46c5d9120bb2f408c4bd5ee3fb21903ffb2e0ef8257fb649"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
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
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end