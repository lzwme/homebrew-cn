class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.258.1.tar.gz"
  sha256 "4b5127a687dfd8cf58bbcddf53e90ecaef64b3dc29b86eddcd12f65babc2de95"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69a9d5fef9a171579de56d64c08b9d98b4435c82567e6cbfc862f5783fafac80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed1ae3a6b3605ec0005608bd921b4a59628a2eebba20f49365caddde7df69e5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9595863de81e02d208ba3312ec651bd3d9c33a53ba212bada2c1309e2f5d6c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "6611638d72ef3ab143f543be67949857a540c14d77686a395595abd799714e08"
    sha256 cellar: :any_skip_relocation, ventura:       "7df86e67f1a57a55b4e90a76bccc1ea0436aed10e6a6b71850adda41b48d53c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caf352be82c7968aa7e607f00f36ce1d052a81d98bf31d8def1123af64b749c7"
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