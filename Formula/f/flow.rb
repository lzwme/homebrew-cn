class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.246.0.tar.gz"
  sha256 "e85c645e7d7708974d2d16a146780ecf1f57498ea33f83c8bf22d7d166a30f01"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3925555c62912127dd1bd2f3da0088f4f05b183f5d8d33148b09e3bfe33271d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "525757ed63aa9db3bc0562a1e7f3a0e101fc78bbbf6e971cf96b7a99f85af815"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ba8776ff2b34987534649ff547aa3bce307b5401447c2787a6931ae51e48f37"
    sha256 cellar: :any_skip_relocation, sonoma:        "d706d10c38992e96381f39b841a1bc28e49d2b97c625208bef1b277de68114a7"
    sha256 cellar: :any_skip_relocation, ventura:       "121597e7e32a4cb199701b0592482bcea886f7222844f03ee4c6441127fe5ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c103c8bd41260c7bb1c65f9e945b43be5f0a0995b3c75ae37e9652d6debb6679"
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