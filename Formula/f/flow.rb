class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.257.1.tar.gz"
  sha256 "738696d0576007d80fb9319a6c03dba98e7e0ccad447b7acb320519aedc9a595"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ba67b712557ec12f56d0af0f533043a5cc56a4a6a7a6de739fe52767bca7027"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21d09f1f54504ab1ff1fd40da38b14ff87ed416bf8c7b100dde2b857f76f8b22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26e7a9f2c7ef4fef9e139a61057ec63f99672575772aac2338d2d08ab9af1ddd"
    sha256 cellar: :any_skip_relocation, sonoma:        "86946d7d08be43a87ca8218161a95446143e4137497a275da3fcf293ecd37761"
    sha256 cellar: :any_skip_relocation, ventura:       "e6d326240d7ab28acca03aa2b9756bab9ab74ba67b0b80aca2426ccd45869f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "981d0432cd0424328efd7c0fabd33586ad4535ca9942647fb54e75a9ad49053d"
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