class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.239.0.tar.gz"
  sha256 "f2162be43535e3998de29649426953020a05ff05b9b1e763691db03b0144d9bc"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40a2822821b0aecd4cd1758443d7ffa757e26c53ba98dffaa07b475fbbff0e8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edaf0a861cd304f917a95e35aacf205c1a144ac7067f937cb6d195c9b79bcb99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cd2508263021e2b0b1573c42f46595256dec22f7a412cef6763a0d91d3e4746"
    sha256 cellar: :any_skip_relocation, sonoma:         "47707e980c8929b2a841f6aa45ee969acd3ac8e0c051a1eec17fae51b2a2a049"
    sha256 cellar: :any_skip_relocation, ventura:        "fb2eefd924a756e5a729d2de5d90231f1eb3d4dca34ade270434dc8b05414513"
    sha256 cellar: :any_skip_relocation, monterey:       "b6743e45bad10a812bd081b69971e2529e2e640dd8a3e31db43484e98e6ab441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2c3e673dcd9a36d6dbda5c31399a881b7e60726b59c1b6d3d006cbd6b6537f0"
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