class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "61009f6da360159eea4757c828f5615000ec7cb3f551bb59935b3c4dfc0a697a"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b896a14bdc98b6ec77c1b7add7b61d55e7c99211c934ebceb93712393c9e932"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b483ae78875a6f3e1c5c71bf04b9dfec95526b2067a934d90c39a203a3948334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04ff98e27791ba58ed694d9c8dde696267ae65646d2c2738145e9376d22baee3"
    sha256 cellar: :any_skip_relocation, sonoma:        "35e04904de9fbc1ea8c658a8682d6cb5d911748884593c253d33211bf444df47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde5998255d96155675bd604ad3af4626a8580d2eba7628c7571cab2e688b7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "163d40d50b3729af8f8930242c880ae511461ec747c3fa3992be91be78f092ef"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
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