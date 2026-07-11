class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.13.0.tar.gz"
  sha256 "1424ac5aa944a32dfcf344667ddcd5dde6e889e76d14fcb5c68f20ce5958a661"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22ef50a18c60ca5b6f01ff129211bece78ef4e4ad3ce6304a859e33edcd745c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "886d2f26b271b05125eb7dc9891e0451be64bc8ab6de8a36283ec5b863de5bda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa4a16fe47cc4dffb141ffcc4e22d8fa3566011f10efa82696ef506b1fb984b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc7e4dbdd5fcd60caf13b96bda495827a9809f807ace416894dec618c6e2d434"
    sha256 cellar: :any,                 arm64_linux:   "5cce415f8404849c359b4a65c0f8ab64f7011bf10f2489ac73057a7ed7692b92"
    sha256 cellar: :any,                 x86_64_linux:  "a8ea345d5aeb52fefb43a6d86d8a2d45aaadb16b520bae58e68b0c15327dd25e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end