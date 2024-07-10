class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.3.0.tar.gz"
  sha256 "cecca23e79aaa3b091ea23784a5d7f543c1cc0b2901e8ff6e495db67e8bd4640"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1722ee1d0c4679a3fd1a74592bf20de4bbaf2dfdc9d5bbb3e8b8b5184fc786c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "342a54aaef775dd7ad22364ae918f78ade7aa97597e2833f2cd6f04bfdf5ac19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90b246a0f243e1e5c64f86af3037c65db52775e3adfc8042d7bd7f1dec050c6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0bb2d186a9154002a59fad8acb765fecedaf9a1e96228ef5b2b26b4773f84e2"
    sha256 cellar: :any_skip_relocation, ventura:        "5581d24c0622a96c0b3adb47e83a22278915d76ab8ead208e753685ff9a83c76"
    sha256 cellar: :any_skip_relocation, monterey:       "92b30301ffe08a6f30691d093837fa2a216c227399145ccc953839c42b66f56a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba551e18902e268a4fdcf03743f638db2989ccd557b9ae96097f530d225866bc"
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