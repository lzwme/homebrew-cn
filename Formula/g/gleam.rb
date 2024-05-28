class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.2.0.tar.gz"
  sha256 "381239535ca1a2b95c982f46569847b722d9a308f84910c8ab0d03d8a6d5f6d5"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f1492b721d21c998a17ff2a8ad519e8026946212ea1bfd846c1cbd3f79d9090"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0361aba3b51dfd6e4fb8cdacb36f1ee0649e3be0dd3340de403c0f27cd4098e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32d911e55c8f40915be464c9bbcf02091379f8e51f893213bd7857b8ab13c149"
    sha256 cellar: :any_skip_relocation, sonoma:         "a362cf2506446ed25ef9650422a15a56ead6ad78e42f53e0cc8a8a885f1d2396"
    sha256 cellar: :any_skip_relocation, ventura:        "2a4bd51f8410ec74d3ba0db665f763e96cad46033f29f489e9a0de6dde8b3ea2"
    sha256 cellar: :any_skip_relocation, monterey:       "679216bda1d8007f832b5caaefd35698fa20fa4d949831cebc8a2c8ba7c26022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ec793c43ddaf724169925d7a258ddccd7021ebb16c4be06ce6aede44e3d79d7"
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