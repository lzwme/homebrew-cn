class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.274.1.tar.gz"
  sha256 "4cc125cb9274e9a20d78dfb3850b336651391d40cfd2ea4c04e8cf57261d4f0a"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d04cca2d0bcab5792fe164a2f2eaf58ddb5af4bb857eb3380f94e52e2469de16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "318bcef0460d3f6ecc3c4464ab28529dad7568e7e450732733b994e04fd180f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19e968644ec098bc75eb79bb250e1ea357a771988d07cc017703aa6c1fe4a204"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b9b4ff4b38dee1ce012da23a6508b1dd0cf93d3157d3b56685df0be9b946dd0"
    sha256 cellar: :any_skip_relocation, ventura:       "c8986e8d2c2a0f7db51812208c1209b9f47d35eed98deaef667ec88e6deb9f7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "072b311ef232bcbdc8827609aba07b68b0c60a18ca19fffc7f0ebc5b777a4e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc395034a8ee909eee7ad558578def28f92af8d072b4693beede4972a77925f"
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