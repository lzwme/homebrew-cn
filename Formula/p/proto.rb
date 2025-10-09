class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.53.3.tar.gz"
  sha256 "288bd7ef75fa99a5a536ba439f48f1b47cfcc77390a867ae74ac50a5e86da07b"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "789853f830599f575f7a143c8be3fcdfb7c9923f834158cec143a98249a6dec7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42e697f31fa148644fa5bd5abec1ad2f2b7b7c23ac41e18ab1c6541855782952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c742434f70f05906f36e6b9654be8a7bed7b57bfc03e4be7b7571aed2e5ed41a"
    sha256 cellar: :any_skip_relocation, sonoma:        "551b5283151a8b9343da72cb0f6514365c6e4a5f1ef5c7d60a0de608ab3efc3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75554c31802e2438219ba09efcd4f0bf19884e3422b159e3b6298d0b4bdadbcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cd96483092476f5443d5bb8b93f167ae339ebcbb8f4d6751158469314ef087f"
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