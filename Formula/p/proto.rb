class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.52.4.tar.gz"
  sha256 "b3d0d9b9676d1c7fb97fae13339d1b9a52e6d933338949efd1e57c5f536d8612"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba8e847f543ab32a79302d4f03bfe1eb837df7b50cfb6b60da1f9f840a9f3ddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab09753ed79cac18cbcbbaca60b97be90255acf7bd51d40eb6b687397bc5f12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e40801641c0ac59317ab6a77fbc3730b1715acd4a650eee392f181bc5b9de73"
    sha256 cellar: :any_skip_relocation, sonoma:        "64c49eec4da59a9438576eb71e36337ff808879f06291ba2a6fc415cf66eeea8"
    sha256 cellar: :any_skip_relocation, ventura:       "f0fa88358e4fe926c2ecb82098a9b667b43972e125a575bba0ac8fc866995954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3af0782e09e8368b8d512387aa1166e2f31ebc28148ce3fb3b16ccab7469bf5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bab0d14b91973528a8cc236f909e03e68d89a388874f3ae6f9cb19d943ac4c8f"
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