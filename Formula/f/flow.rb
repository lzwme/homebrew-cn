class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.258.0.tar.gz"
  sha256 "389679a70fe3486aaa365c39e7a105f5a779bbf2dd18d81df25c1eb066eac570"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e94fed280d4433e8c4cb61874b75fc34ba3df05856aa4abdfbc9e7a2caa38893"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0ca191ffb369eb6a5ef3a0c737537893d7db8d639bc13b819586a95a854d164"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68182959ca32d1233e8071e8549a10c639d9678f0c16b430c339abbb33202265"
    sha256 cellar: :any_skip_relocation, sonoma:        "60c6e33bfdf276090f265fa8187b34d9810149d236e30343726fc2307a83c462"
    sha256 cellar: :any_skip_relocation, ventura:       "957ab8158c4772fa0b88a01be871651c744394d7a0a465834d7b93174bb8be00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60e9d1124cd4f3af67e03ce87e3ae50bbf0953f3ee3807643532a97d354a08dc"
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