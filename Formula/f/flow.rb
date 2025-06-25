class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.274.0.tar.gz"
  sha256 "0ccf31afc7242b845f799779771e52b3dd46254bc6b6dcf3576e63900452cbed"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f18fa6e836d9ff65f1a651a39b8c2a3f7d439aaa2568ffc26f4d2cb33296116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b689f7bf1924697ea141cb84fcec70e989d3be06c55f6b3d7bc0c828a046e1b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df6a0b161e430a298f2888ae1b856472b6c07c5087abcf83c2768ed2b4157094"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2e166ed68bc6f0094b4ed9430c841fd63dfffebcf0bd03c602f8a224b103c66"
    sha256 cellar: :any_skip_relocation, ventura:       "98f64575ffe164a4c0ea7e042ebbb26e2eaf246ffa727818c272c153227c233f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1b8516d03bb87aa1b1e7f930b4dfeff013b08b39efbfd6c297d498394bef513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc68823832b7be2a1b4ff5a3f48dcca23be193ccb75db634aa9f6cec9141a8a9"
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