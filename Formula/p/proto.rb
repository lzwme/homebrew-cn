class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.51.6.tar.gz"
  sha256 "cb46d124e52a6413e42486d24a4cc8fe6c8c4aea06ca4afbae8371b54e2cf298"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e53456f1692b381f5cd67a4149700db2ffecc61020855135f414bd183c09bfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b77c12c6fd3e48ddd778181f2cdea1bc106332b4f2ddf9c1ac1cc38d0ee6c305"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cde8e71dbe0281acfd574055b4fdb87137f26851eb532dd441577b7d68ae181"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0ccff3d8073f64475c29d82f4cc564a30e9b96bd4a2d6cae371ea6da3df9832"
    sha256 cellar: :any_skip_relocation, ventura:       "aa30fedd4dbb46d5f05260b089c20f9ad8552f3bfd4c975b5e34cac8171da5fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e8ba671ce0de55774add20adf5362c21f58b4b2907b6270d6730f134b84a816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adec7f4646ee869dbacdd74aae8ecccae06ac466d9cb6efc6409a2536cd31e77"
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