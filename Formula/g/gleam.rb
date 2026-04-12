class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghfast.top/https://github.com/gleam-lang/gleam/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "c76b7597be4b39929f332e30810baf40b3a89a08e42a40bd5e9d165420874e71"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98cd39c96e3d74d3d31db7d099fad3626148d3662bc2e672635967b3f1224e9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c234149c81268ad127bda9262e49c682d5586c6bf5fc0ac30de72609b21da9f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5e360a7d58bf12d8e4db2f330854bdf2bd3900f639cb98f38bcdf47b87ad0c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ec3ad9fe40f8b5e80fabb6a6a54e568be5ccb20b35581f209098118a4bc9dce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "863ca926d79e39ec1b1204f45ffcc88e0f082b78aa959f703e7065ff6bc73f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "686c025b24bec3a7bd09f491a31132a6b4336fb25c0f2b289fcbb4cd12b633ac"
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