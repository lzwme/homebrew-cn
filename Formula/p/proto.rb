class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.61.3.tar.gz"
  sha256 "7acf16ec9b9c6a63e1261305c2509d665f8371fd62f2a1a57b8e2c1cfefe040d"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ab10cbeb318c818e3ad3e34266018d736ff2da7b2c4120c025045ae4a480978"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9d0a3810b6f6afb7694fa824550f29a3f5549487a6227f2681aa1a87ac028b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bed42df8a1ace9a367695c93e0b0dd1d5c3ee13f6b29d6a729ea76e63e18676"
    sha256 cellar: :any,                 arm64_linux:   "23dfd3c1221c4d211da3bdcf61908ca8fc451067879ff0f6de2c4ae518a47b2d"
    sha256 cellar: :any,                 x86_64_linux:  "a409412b7931855692d4fbe4f07dcfbd1ebae5c93acfddc0e05f351d7a21bfe9"
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