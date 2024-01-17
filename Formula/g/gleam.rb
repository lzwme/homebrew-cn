class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv0.34.0.tar.gz"
  sha256 "1528f46ccbb4bcc4d783869f359b3a386c59fde235c1054d83d09bdc2ff19f35"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6471261c897d8c894b0e447228b5d7dcf8842129954fe9ae65fb6e03f1cb67d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7b2d1f70104dac52de4a284b5167c9207c264830d5b1f316a8a1f312510613a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7a7d6364571d05318a376bf65e7af9a35a7fba49ad3cb7d0bcd4db7e0562ca6"
    sha256 cellar: :any_skip_relocation, sonoma:         "467374c34c92e5966e6065870622b884659a4ced981ea632eb9a235915f129c2"
    sha256 cellar: :any_skip_relocation, ventura:        "512ee05e9f3882614718023800c77ef585ea6b6eff1234f4bb85ed9fdb851df7"
    sha256 cellar: :any_skip_relocation, monterey:       "bf0346ebbc27e5de60d13a15a2d441715da8700f96e31e4cc2b2b432c9255a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08b3c99df887cb9283a9a009be49969dd018bbaed48633fe21ed0cf0d67089bb"
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