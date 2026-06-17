class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.57.5.tar.gz"
  sha256 "287027a81af521cdd0dabbd7002f692f3119e59de40718fa13651d41d9a1f3ed"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75285430ed176776ee3311aa05368dc76d220c34591fcfd7f2ed3a8b3ac74999"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4fd23fdbbf35c370a515b57579d38ee1c78edae9dbd3a750125d4567aa35896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67b965b7f65cafbbbf45ae17c12bc8260e19dced8a5d0c924d7dca24f0c5c36f"
    sha256 cellar: :any_skip_relocation, sonoma:        "730db42eddad5b1575d95b7bc749412ba26430d8f19fd7b662706ca26826e0f5"
    sha256 cellar: :any,                 arm64_linux:   "09a92458454b77b2c5bdb4a6d3a7f07b1ddf0a3d3ea094bef7d4bd5ae0ac4582"
    sha256 cellar: :any,                 x86_64_linux:  "308ff1cbeda5136bfb8efcf3ca1f0b99a65f2ed8bc45725735d0e819d5f9e83e"
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