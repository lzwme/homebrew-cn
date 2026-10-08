class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "10e97259c26360e1583ce5071556915f791011598049828c2e4c0cfe1435b159"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98dec028532cee8059182a9894e79f022c3bbf185ef89336a2a80639636847c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f8f9777979eb9999ae3f8d3045f8f0d0d80447c14e13078ef13dd554090d1d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b41a5d452f8fcadefe4e6500dabcbe7046367f81a21d00a10b81db7c3bc2070e"
    sha256 cellar: :any,                 arm64_linux:       "49ef55b30b3eba21a125ae6f98458fb9e55c632049c9110bf3c5a25eae134fd7"
    sha256 cellar: :any,                 x86_64_linux:      "1ce348586f47ea963832e54f9cfa904399f809d1b038058fd8666a547874fb11"
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