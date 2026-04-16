class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.56.2.tar.gz"
  sha256 "aacdac79bb9c53fc9015e2f395ba0f5cb52b8e151f04126ed90164d1aa883dcf"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b366ed40e16a918afe582e010919ae6d6bb9ad3e392e02decb2e8957f7c6d912"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02033df1b926ec5dd3470b3cd6b95dc496676e2d9762110fce9e84a4b007047e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "535aa7f31772bfa08b1824bc34aa088e3c0827b7e6b894ae7328b6c1b7454c5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4538e8953f5548928d6ed2c06cabf5eb7a3dc610936e126c5231fcf442b65d12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2c0bc909327742beaa32b1f039ab423d1aa2c3d1482a610b56fc11803c0b052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93287842148da677ed0a9e878d4c79afa65d10fdc7ea7547fd1199004c3b7bd6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
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
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end