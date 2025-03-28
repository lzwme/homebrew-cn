class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.266.0.tar.gz"
  sha256 "282554386880539918ec5ee52de6387b0b59d159733496d1405d68c58e79da15"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b478616df7af0c66f4dd2a3d932f44487ebb249fd82b17da390c843bf49c2f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25a6d40473d66eae0023b777a6366f4542c479875c9a88e42cd55112c3f92496"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be2f4097b24c7d363584de9740555e623658b2eabff5412c6743f6db7faec50e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c748ac5d0694722f4748ccaf830fd709667e965cdb9f60fa1ee77af42251644b"
    sha256 cellar: :any_skip_relocation, ventura:       "3fe48c2e5eccea10134533d0a6c950e017b693485f7d604c54c5ac406716a350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c051279a46aa398616855053bdf6108ec2762e8d9494cd67e2273d1688f0b26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dce283ebbfc12ca5f7315795ce456a35cb7b87c054b1593c290e99fe6514384e"
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
    (testpath"test.js").write <<~JS
      * @flow *
      var x: string = 123;
    JS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end