class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "3a72eb85b993e36a9f49196f16086663b715f96d84e514900b4d7816bbceb1a2"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6f182d799eba1f37731d6e976d18d1159ea1ce93bf920bbe533fcdfbf886aee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f2bbcf4411cadc15353c837ce4769b655b6991a5e0e850caf88b4276c8f6344"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adac3e0843c1c9cbc3ab138b7f688977af7982c5abe4a312127a962f4bcb28a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dd69674896ce3f1d92f21d2bd5224fbea6725da54276d7286c806757bd7fe98"
    sha256 cellar: :any,                 arm64_linux:   "f05ba9f08e09bb66270112ef7242bed27157849c25f12894000ca71bc1f1a77f"
    sha256 cellar: :any,                 x86_64_linux:  "2c2550fbf304dc17233fc621394ae2bf972706e97f6ac972c2e998db0c38f6db"
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