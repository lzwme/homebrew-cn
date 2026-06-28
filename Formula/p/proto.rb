class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.58.1.tar.gz"
  sha256 "93b77c43c9c8114bb09f2a2fe4de53b8b8e007025ec41827852b2742a1c85b2b"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92363f5233cb07b4dee372774fcea9fbf697b521e987027ae3b789dd368ac2b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d865af0630c8b6c6e04daa54e3b3acbdbe3480043838a9c4de877c00e4e9870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8a46fb7057f265e201a4c2d0ef1ca1dee21e51da188e38f7022cf4f2dc9ef5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "51c0c3992b40a1a0af68c55735e0f1ab3d49636c0f89a6d14e7f51e38a9491ad"
    sha256 cellar: :any,                 arm64_linux:   "7bf2d35f6ad23a2c72ab1a24945011fa30001ffdd621f7ebe6af4711f89e980a"
    sha256 cellar: :any,                 x86_64_linux:  "a791c391a132552fa9efd6032fb645996caddab402fac8dbfa8830ceebe55a54"
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