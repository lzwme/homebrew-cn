class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.5.0.tar.gz"
  sha256 "0342babfbd6d8201ae00b6b0ef5e0b181bce5690c703ffae8dd02542e024c4c2"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dfb6fcb2f6ffb26e1a68e54a7ff2765b57b3daaa2ccd5b2479d39bbdb44dc4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "542c7cf17f6d29eeb76fccefca21dc332193bcd08f678b768f4fae16d9901391"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ee506792677b596f5994ffb85a00a3b1fcf9ce1a8e8f9d8c09cac475dae05b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "904f53ba393f3d603b3fd99368cc8cbefd09f31634be18eecd1db55d7988d343"
    sha256 cellar: :any_skip_relocation, ventura:       "e485670fa98c9a400e58716c465fb52b04d0f6659671a882bee8ffa3f71c11c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b879ad99b995ae6e78117f0db3231a007f3243bdaf93d151cbe6300609620252"
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
    system bin"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin"gleam", "test"
  end
end