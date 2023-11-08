class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghproxy.com/https://github.com/gleam-lang/gleam/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "19eca24e6d64a2d97ff482b9d204c96ac17c4ddd41243359862606f3d18b0763"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "645decd71b1148b59b1680b0360d300cd107f5f7d7125f9f841a0f39dd126fa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "581f167f5289332dadb6e238826cc29315a324aa84d7fcad4bae7cb6bac17e30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "813b2aad999760a24deb36fd926e1c02aa9a8002f9f36ea2e2f4eec35b782d39"
    sha256 cellar: :any_skip_relocation, sonoma:         "aef846861cee2fc4edd9b305162b281f1ee971fc2705785cc115e6c19c19ea36"
    sha256 cellar: :any_skip_relocation, ventura:        "a4c505bfe99bcafe8e985a89d001c98eb7a85fe2694b31104d9a81f605bf164e"
    sha256 cellar: :any_skip_relocation, monterey:       "5c2e575e327dfc1f82de6e46ca241daec08b41d528d7db6d7f79baeb6fba6a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "252c27b7fba7af5b7fa9c0f5581a3d189a13fade402c829b54e1c38e29126812"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end