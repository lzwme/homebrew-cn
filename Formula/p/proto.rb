class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "9539c07ada21da0a0bd0936a3b01a35629c4a853f1cce99ab364f17a3537bded"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3b174e116dd35a926fc88654d1ee2dac9b0dc8563354b0aae185bcae81e2bac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87758416e7dcba75ab669c84e4f9d6ed4b7c406760c94d10c4367c064609536a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fc403c9e1b98d11ad828b36eb4bdacc47d6b7e18d17be579dddb02681c7dbb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b88689374732a6e9018fade9b1e589caf1109ea5bfc1b2576dab7437f421875"
    sha256 cellar: :any,                 arm64_linux:   "d0e5cbac00bc4a7e09ccf35f2e1bb31e4620e630f36e891527ec1ee95ab5b6c5"
    sha256 cellar: :any,                 x86_64_linux:  "59dec28396479d06eac3c1f1f61109c10f97b014a64fc3eb7c36b6f1c716752c"
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