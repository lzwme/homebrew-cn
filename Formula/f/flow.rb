class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.241.0.tar.gz"
  sha256 "869d519cebc90640fcfddf0a18709f1aa304c0c5352187797c8c005e33f3b8c9"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "908c93541cb5246a41ee1f55f53c13cd0bb8443546937880ccd01bf792954257"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93fc36fcc796373af9d83c62122a6b47ad7aede2fe48e5b18f06592856ab5989"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54f6756e58c22923daf1bb5faf236a134de0876ed719695848c96cc77f4226e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "798c56483e990eaf1cea630df154e23dbd8640921f66ee9b8b9b74c0dafe7f1b"
    sha256 cellar: :any_skip_relocation, ventura:        "f29031c2c2c72c0b7478b3af0cbf3c777ded9c32662324907f2cce0558dab5c0"
    sha256 cellar: :any_skip_relocation, monterey:       "1dd9e04aaccf296d5d45833f21e264b6969f008cd9bd295f57619735a37274b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d3e4ecc6f39d46da630471712d838e4261e715a066cda235f81cf9ff1e78c4a"
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
    system "#{bin}flow", "init", testpath
    (testpath"test.js").write <<~EOS
      * @flow *
      var x: string = 123;
    EOS
    expected = Found 1 error
    assert_match expected, shell_output("#{bin}flow check #{testpath}", 2)
  end
end