class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.53.2.tar.gz"
  sha256 "64f1693eb48f24a793fbd7ea5a156e406ff22e810f1f8803ad441065489151c7"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87b607543b52aeadb269311ccba135052805720ef58a9e1b444fdf37ff85e14b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1591db42982d4658fad580631abe924fbb941759180c36c1321fd7530030ff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15e3edcb4aa0a16b16cf139bc8e3c8386d9ae8c1b93b7c59bbe0a71702ba5a62"
    sha256 cellar: :any_skip_relocation, sonoma:        "e66c38a7967aa5ba2a8a3b2ecae03284bb19b89445af7113dfd48cbad40ff0b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53423ed977786ab58cb81db28b8a97da6ebaa815ae3bdb07491913f519465b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55768ece3ca334fdfa439a75bbbfa89ae14122f4db0a215fdd2b7779c7eb0866"
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