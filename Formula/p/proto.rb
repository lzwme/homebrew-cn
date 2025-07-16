class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.50.5.tar.gz"
  sha256 "9482fb7321d886c9a2faef16fdf0e1f0514e58fc4ef3478143d04facc30ab72f"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11d9a72294bf381b3ba7e5cd2b0c211820021dde3c1580793a3953de5080080a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddcbf6066652abda1b8d9ec7cec3722763e0dc999be435f57f666c997e9e9c2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff38067c2f2e573eeadc5eccfba943dbfb9fcae04e684db205e4bab30d5ecc7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "235ccc252300814808a3857453f1bb1224681ae796b46ed7c9cf5b9304b3e4c4"
    sha256 cellar: :any_skip_relocation, ventura:       "55d64f354ecf26c896d917842655f3f4049e3d9173797b67cfa46be9d2a59052"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bed5fb8cff0b4d70f139e79de4372bb37b8cab8157a8d12664e331c128424c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bae06bc7b22f41b9b764036e9faa3ea430981908b3009706d657d26a10ed0a2f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
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