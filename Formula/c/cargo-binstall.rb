class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghproxy.com/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "4a2991eca85d2fb184b7f575493aab9b912f4e5f0efca5045cd8a32745546334"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6c012cfd7587f6213555eecf529ac2375d1c52974e1f40996e3a40330ff3926"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79e10a512cd25dc72aec5e7559b946f1bab547bf1d34d0bbbbe73c94327072dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fdd7115e50950573def0fa25db69ad265da333226ad12a9059135ac554286cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2aa319ed62c5b5e4f1e4984e13943e321f98a9c14ebaf51c443387d947973b18"
    sha256 cellar: :any_skip_relocation, ventura:        "a0da24977edb5015f32febd510ccf15d21334276503d60ee4d6d3ffc2ad5326b"
    sha256 cellar: :any_skip_relocation, monterey:       "048c900f0a2d23abfaf686bf848b266df07f65bc52bd289341cf095518d40ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d2dcad64c5d9866b408e65a0bf33187ffadccef6e6b87706a1cb4bb1baa7f2b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end