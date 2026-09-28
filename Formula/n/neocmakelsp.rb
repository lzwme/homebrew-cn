class Neocmakelsp < Formula
  desc "Another cmake lsp"
  homepage "https://neocmakelsp.github.io/"
  url "https://ghfast.top/https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "eb88d467816f67c22cfa864f3d3ecc4eb5cfbc1afa018fac61a23915f21745e6"
  license "MIT"
  head "https://github.com/neocmakelsp/neocmakelsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a030af044639a351fd66a5dfb35b405e73358088af562bed8480340412fce2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "196eed60fbcad6386687f98811b2cce61f28f6e4269471e46b4298e9c05f7df6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6dafc9bede5c5cb4c3975065ef162c8d7d195564384b405922c712bab67ed2d3"
    sha256 cellar: :any,                 arm64_linux:       "3e70e1502cf5a355e5a06a6a1760f26ba872e2a2e82c9493cc103ce3ceabe797"
    sha256 cellar: :any,                 x86_64_linux:      "d4c1d472e7ed6e0e36c8e5184560bfb5ed4bfe4447fd73a59f0672f3242646b4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.cmake").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)
      project(TestProject)
    CMAKE

    system bin/"neocmakelsp", "format", testpath/"test.cmake"
    system bin/"neocmakelsp", "tree", testpath/"test.cmake"

    version_output = shell_output("#{bin}/neocmakelsp --version")
    assert_match version.major_minor_patch.to_s, version_output
  end
end