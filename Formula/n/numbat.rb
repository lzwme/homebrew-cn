class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://numbat.dev/"
  url "https://ghfast.top/https://github.com/sharkdp/numbat/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "8b368bafe05eb25f776e516abd94c3a4899b32e520934b6cb4d123ec03f1e9dc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d88038adc361ef733a2bcb763c36cd2f8b04433d679f6aa8cd4b49200f0a0564"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d1c502f326f3a8ac6deda047f09ed45baf17eb5151888bdf2a54e49c00f621d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e14f86d2065812196825b8d5f2cccc9df436a5e3c14a31aee77aadaa6c37f193"
    sha256 cellar: :any_skip_relocation, sonoma:        "245dfbb71afb1a0a86d79980593aa41417f4ad273bb7cf2aaf2a3107f6582fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b63fd69638a935d8dc7c9bc833c55e1d20a9b61a5d2863970be398527c9958b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68ca9518a4576631532a16c8b3a549eb8cbf5c985274f770fb8b801c759892a2"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end