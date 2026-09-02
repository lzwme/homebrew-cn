class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.61.2.tar.gz"
  sha256 "e83e6dbadd952b02eea43fe7ee9a6d651175538e440cac25249691078c71f37f"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adf95fb905a0442a183433464e49bc36e108435b73cceeeac2b0f7028903e357"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27767d80c598e25becb21304f21c3f98b661f7d8d524abfdfe17589d6b8d4fcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39b1e0289b390fc0862b28d375f0470e9aefc0c955d868cde9b7cc54d7948cb"
    sha256 cellar: :any,                 arm64_linux:   "bf4b3b6741a7a7db81e58185e2c0f119967924ab4f714fac4513cdfdf02532aa"
    sha256 cellar: :any,                 x86_64_linux:  "e48fd8aebac11091320c6953fe5781d54a9d904cbdd82f69a193acc0c63c0c1a"
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