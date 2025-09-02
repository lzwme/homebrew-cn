class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.52.3.tar.gz"
  sha256 "8a5cf50a940c5170a4470e02c5ef0b8838ec5a136232c6aa812bef494b18f2de"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd814d01b457c219cc6bf3335c31ade256f2ec6d5295e7f189ee1bee27360c4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a91dd1a00f857997b77f810772bfdb5df2316ad79a37e559fb007ed180816c77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "659b218fc3a6c00859757cf4a43ffb92483034c172f996e9342e5d068e823206"
    sha256 cellar: :any_skip_relocation, sonoma:        "f22b2e39a20d7a48a08f0ecaea19021897929588a5562539ad887a88d44e2ec4"
    sha256 cellar: :any_skip_relocation, ventura:       "92ff3080945c3f1544562e380b686e3cd09ae024a7d3315c829074af1d8b7484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9968edde5dcfa3fbbcc878b0185ab75cd2122eee056cc102c76c19493d7ec8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a45eb070885ecbc3642ca03ff82eb7dbdcff025eee05f54cd00e29c593dc0521"
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