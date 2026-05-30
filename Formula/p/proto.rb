class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.57.3.tar.gz"
  sha256 "cefdd34b85e190d2e0913623ecffc40be33f07ef1ffb63d20265f4991851b91e"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80ff1868f03fe6f8332c4e05b5d19a7fe9d2c9f03610a74b48e0a3c887586497"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2fd00fa33855cb8fbbdc266ec08b952d6c38d7162973354cf86d92dab619aec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b094ec0b4eece8b63c42c9cd22af861876935ced065853f490b0f4c6dbabf3bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d2600141a009a711a694c10a76acea9a8fe6ff88d7b35d9660b904aeb3c1e05"
    sha256 cellar: :any,                 arm64_linux:   "82906a6417c1e9830f9be46296db2333b5258d5ea265c7f5fc3f7bf5f1473ac8"
    sha256 cellar: :any,                 x86_64_linux:  "57222cac3d9e4973407c3559144dc2c2431db0da391667e334817034893f444c"
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