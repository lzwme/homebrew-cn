class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.4.0.tar.gz"
  sha256 "ac889a2f3448960d97332f24531a41a50cf693056e578d501d24ee3812517607"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e774ff8ea3b52a7af09a996da1ccd072f122f47087d78b8fb7413d7db89128d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efd2afda43349c8ed7f0ee65005241e2380c2115b9024f1d04e892f4981e6910"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8005b1384bceb42ed126a56047ddf18b846acacb6080ca109c671b54fad0562"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2ce77d51ff11dd4d2a14304fc036c0b8ae1bc8b6477dd0b3e97e1e4f82be912"
    sha256 cellar: :any_skip_relocation, ventura:        "c20cef4bb736dc3be3ebc717cac6cd91766f7c4ef524fe160d320726f6324b76"
    sha256 cellar: :any_skip_relocation, monterey:       "e63784ac767d507ad5f7980fb132162a8a0997d25f3f38d947c9cdf35aa5d629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74303655f18b66645fe986bb39a37e0279341f746dc61d040c485f45562c2b39"
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