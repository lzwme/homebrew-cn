class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.245.1.tar.gz"
  sha256 "71a2754f11945ad522697d11f645d18b6ac13fc0d96432e3e23d1183e5be08b9"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06244c2295a26c69be0c9b9754ca5cfea64d8dc48efbbfea10ce714178f70551"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d39f4cfd1332de58700e78d115971f43167a7cdc5deef234fad3ad500cfc7a47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e14c5625643f6d28a8976b0b6a12bc28aa7b9ddfd62f61396122164652a41cb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1d78ead66f9588a5be257888384e60062b89b36570e7a7e691ad9403d9d5c60"
    sha256 cellar: :any_skip_relocation, ventura:        "e363eabe2b4b85936380c108970a20d09d317a09391b75876daeaaa7af1411fa"
    sha256 cellar: :any_skip_relocation, monterey:       "de1b14188c7a4ca9f2757f1c07efb17d592a6d96c8ef39ddd5f63d5ccfdf4cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5443e9dc57bad99aa4f603ccb651c572435a44dc8b2ff8cc86bbd9ef2de68bb7"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "binflow"

    bash_completion.install "resourcesshellbash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion"flow-completion.bash" => "_flow"
  end

  test do
    system bin"flow", "init", testpath
    (testpath"test.js").write <<~EOS
      * @flow *
      var x: string = 123;
    EOS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end