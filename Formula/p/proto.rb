class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.56.3.tar.gz"
  sha256 "c664a40479e867f225c5ee8e5a4583808babc836d8756d3b048ed4f284b8e6b8"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5606405e04c03d19300af09f87a6cf943a657980d7cb3e346b5227507d8597b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "288a8d43ebfcd8baeb315cf6a5b56c6050ba14d82c73f1821ab8aa57a7aba5e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "187ff1d091728bb875c45f326377de4aa2c89698de7c2aa6f34a7d464b13efeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4d041dec5feff9675da7228788428f75dfeb0590ffc7eef055997a411ceafba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d544636c2bdd99a39ff37cb51b6a5de23a46f142bc4ed70f5968831f1048290b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82eceb4fa69b2d2aa3e10aa990ec203cff4e701f08fda970ba2e908cd530ee62"
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