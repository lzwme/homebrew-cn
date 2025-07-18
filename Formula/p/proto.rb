class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "e6e529d1b1ad84d46927bbb48d35f95bc18647413423ac298ecab18278e24e02"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79c52023643e9b689668bf7261319a6fc2c040372e85319f4d4993523889b010"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60bd2bae381079cbb6d03af0e3c5255d23dbd2f4ac161c4a0987f6fe0b934070"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "150f8f318b456803563292a789c83293ee5bbae3553aa98526e23e1f97ee592e"
    sha256 cellar: :any_skip_relocation, sonoma:        "efebf0a300e4e2c1d7c2d5fcc7ef5033ae7b0fc9c858b82f426df4d25a59518b"
    sha256 cellar: :any_skip_relocation, ventura:       "c4c5df94d0f71f70f43f5824eb323ce3af8c822930bd9ced91851de975ccac4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94af406e70ffbf648e07fe2822e918cf382d6c67af347ba3f414d5e22afa261a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f9b6f0652c5c412bd4a8500b6e388297213afda4fd54e6c31d64042824e9f6"
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