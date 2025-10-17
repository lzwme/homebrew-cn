class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.53.4.tar.gz"
  sha256 "1b40c9d740cfedb8afddb7b5c4e878f8f98672a4c3c1c57925b693d06498d06d"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3d8ece2972b5dab648d7b678b75747abd362f2200a415feb162c638fd4ed3b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bad9645e17a60054628747b72edf74590f7e14fbaff867ec8ca92dac3ff20dec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad2ac303106b17b798a3fc382561a769b29fb8c5442247ba90eab0b7315385ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "57e1cc22c3fa79d63d84b4f60b021b4d5855dc37f1cbef7bd2cffc310946b84a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a927752bf67acc24164c23b793b801adda5f809e6f5f47c64e5ad1bb9691d673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4c5b5b6ab56262fe6d9b59726e3c9432b0fcd1e30ff1930a390be31174fd4c2"
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