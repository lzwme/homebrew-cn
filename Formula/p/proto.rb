class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.55.3.tar.gz"
  sha256 "fe56d7987264392edc6cef75cc0f08e12c45d7f6938b33ca9497586dd01ac2b4"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45bc82583018c764025d498420bc7a71377484dddf7ec94ccee3af628fcf6e9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ecd3ead7581e3b01428bfcb179073ab14bf128a33a0de171e9a3c7ceb1e70b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "796f8f1305b5094bd66e61f95e90bf3c41ccb33c3623ef1f4c6dc981a37d152c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1def6b2450dc13968b25d3054c87dcfa52dada241ee86c497e070498ffd9cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a7edf102207d77fb671902a0f2884f79278dd6c40fa6be743c7487b6baf701f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a01e9cd5da704ec2cd93e5d8c4e82c4691d519bf703c67d1bfc759c95a0151d"
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