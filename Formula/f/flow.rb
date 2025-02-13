class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.261.0.tar.gz"
  sha256 "9d8b7886cf86703dd87bf5a290db347d9cbb13f181777f09ee8928009d21d408"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f131cb58c497aa84d73fca1795728494491bd9fe2b61ad1eaec1a994c4849bb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d1d7eff2716d60dda8fa5a30d17b8a6cee3aff8ddccf11307dcb3017fef87f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf7e3c0e396fc162bcf89dca764e789eba5198d911b85068c24f6acfa6119d13"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cc290cc55ebead19fe6ee78ccbe9078055810a6f36bbe8d7b3dca27dfd6b9b6"
    sha256 cellar: :any_skip_relocation, ventura:       "40a8b038dba0dd064e718d53fb5b8abf838e0a8db2cd5876d1c69d95dc84e678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8661541d4e9b14896f1f89fef5e87fdb7e17c0256ddf2dbe9b298fed4e7a6b66"
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