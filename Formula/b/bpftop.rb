class Bpftop < Formula
  desc "Dynamic real-time view of running eBPF programs"
  homepage "https://github.com/Netflix/bpftop"
  url "https://ghfast.top/https://github.com/Netflix/bpftop/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "cdbc2d35b7394ba84cce4136e1a7d0b79b41c60fa569b73ef318815cbc8647de"
  license "Apache-2.0"
  head "https://github.com/Netflix/bpftop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2e2e0eaa81d907733ab69e9749c01f27ec2c995ade7a8048f5e3523444af0f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e308c0d8ff08aedcbe5a4b304b366fcb50c93e5f10947141f05582da43e11811"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "elfutils"
  depends_on :linux
  depends_on "zlib"

  fails_with :gcc do
    cause "build.rs needs to run clang and not shim for gcc"
  end

  def install
    # Bypass Homebrew's compiler clang shim which adds incompatible option:
    # clang: error: unsupported option '-mbranch-protection=' for target 'bpf'
    clang = Formula["llvm"].opt_bin/"clang"
    inreplace "build.rs", /^(\s*\.clang)_args/, "\\1(\"#{clang}\")\n\\0", global: false if Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/bpftop 2>&1", 1)
    assert_match "Error: This program must be run as root", output
  end
end