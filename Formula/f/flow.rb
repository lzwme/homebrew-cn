class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.229.1.tar.gz"
  sha256 "1d45d9e8da6f2409e6544068d15ce200e3e9c9d7187219b7bbbe144944c97ae2"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fd696ffe295f0a8020fff23ea39c508cc6a549124eb367c35798cdfb2f7b306"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9886d589711c10473bde8f207444ae3bd5bbdda2fcf54fe583c754e9d7b9fc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0242317c0b62d8fc26bf3309b5b0548e819eb05dde48bca1f4c1dcb93e6709d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "535b587c7ae1080dd8dbf7c8390e7bb20a401730a8535ef341fa2f7dab0f5dea"
    sha256 cellar: :any_skip_relocation, ventura:        "a6e5505d0707eacfcf292a3c03e9bdd32b4cf5a2be7b8fc685c68852f3c04594"
    sha256 cellar: :any_skip_relocation, monterey:       "877bf32a10e161b6ea9f167331371cc950e7505b0b27faedb51c0ab81a915344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03843bfe936489111942c1d30b0df725a9ec9903968999517025b1a8264207bd"
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