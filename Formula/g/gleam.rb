class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghfast.top/https://github.com/gleam-lang/gleam/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "f7a21e5b9f1d443ba3fb9c30c6137475ee3ce773a9a87aa59fb966c5141bd8ac"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7c18312a1f9e5c3f3fc2a7f549f06eb7afe6e6b5ba0bb1e35fb21170691df37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffced52568de1303be3c2293a0a08f685987cfb0f1239e878b331f762367decb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "282f2cef4b9100bc86a74e1dd33a123e2906068fd0d5bdf32235e40795082b72"
    sha256 cellar: :any_skip_relocation, sonoma:        "1017e40cabb1c5dc460ab3ecca1c913c86312782a190cf15fcaa817a2679241b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c64d4498ce4c239dab4d4fdd868e77c1148db305f6c35fcdb4dad19f41cb23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb38b85d0c220af212b32cbc7814ab207c9c61bb19843303c92c98c5a4303bea"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end