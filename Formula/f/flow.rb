class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.225.0.tar.gz"
  sha256 "c230198357fec2b276f02969ef3b3215a4511c4582cb85a24f2ed4ee9d0c878b"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1fd9f4f000fadc991b1d4404dbf0cd0f90ffb1de496153427891e8dc9b489a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aa0cb58e5a546089aa7a846aa113055c64d3aa1698b3d82fb05b9b46e25f4dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ec40af6c66369d89f8c5eb9b5f96112121808d5107370289620e786e6cd3ed1"
    sha256 cellar: :any_skip_relocation, sonoma:         "41a7c874e5fc6b56a302ce064683c8197ca7e774d97d7636dde1b6837d9796be"
    sha256 cellar: :any_skip_relocation, ventura:        "b18c4fce354ff7364d8b86e1d9f84f523fd0527030126824a3b38f3eb8dc8a0e"
    sha256 cellar: :any_skip_relocation, monterey:       "5613e71df7c65018d5fda9587e445dee77d1f9331604e4cf006d723dec8f1145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52abb100d4009131ee78e5e9639cedb2636d707699db49f9fb181e9667308730"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "binflow"

    bash_completion.install "resourcesshellbash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}flow", "init", testpath
    (testpath"test.js").write <<~EOS
      * @flow *
      var x: string = 123;
    EOS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end