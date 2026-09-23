class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.62.3.tar.gz"
  sha256 "d9edee09cf9ed53d139012c857e649306e9dd9b7928f466630b806d465080c9a"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14555751aa41a709f3ef2b130999958f2d197decec2b1a234527cdcc5369dcf2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c31224ae7bf0c1f94f35a4cdecaea65b4b441a41d17991153bb5816bcf0edf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3da915439a88d14a1fe592eaf0dcafef5c775cf5a463d68eb86c82945454b037"
    sha256 cellar: :any,                 arm64_linux:       "52d92fe6d9d8813baf7a45573791b3a00ae6e4dcaf24f7a82db72ee3da90c26a"
    sha256 cellar: :any,                 x86_64_linux:      "aebf3777d297dfb9d80bfc11c0844501997b4ce48cb4b4eed783a0e1dd61aba7"
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