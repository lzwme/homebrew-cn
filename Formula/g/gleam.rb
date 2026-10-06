class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghfast.top/https://github.com/gleam-lang/gleam/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "1ee53459e1939cbd8dd4571d8268d7f74123fc16f36cc5241e4594b808ee9cab"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43c0e7ac7b4dda3f899b0ce4a89e23cf5f8d829130180684c3481a5f28c85d62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "359923a3b342892a9a945c3d8e8bc22f43c9f6ea4aebae4366fd73c7cb5b5e08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "40e7b87d5089603816e6af8487cf00c2715101d89ae4ace35de71ddf32df626c"
    sha256 cellar: :any,                 arm64_linux:       "e9eae857c708ffe2f3bc6a7226e210f1e874801d67596ed54d0640670c76bec7"
    sha256 cellar: :any,                 x86_64_linux:      "1997f6297b500e2314fdfbc35b929e90d8e8064395a700675d87a287a08d67e4"
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