class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.238.3.tar.gz"
  sha256 "4e7bef8d95dfd703a92d4c721510b38e3434581f7a09ed63f1eed3f4db9dd004"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c32313a0fec2cfec746d6b6383f9646687e5dce8027eccd87f9a7fb1d8ad239e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f5db9a5bb5e664e1bfc062ee5f225f83cbf82a5fdfd9a844fab4165d7078df0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12ae5c779e086e7ba093afb2df5ec54f81403e6d35a4d6da7b1e70634017aabc"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6dc63748e85c778e3a683854d6866e6829ebf729a5cb5a01df59096f7eca3f0"
    sha256 cellar: :any_skip_relocation, ventura:        "0c18412cb7638eb14a65f9c21f9337c3c9e53fee840ff351820ac05875813bf1"
    sha256 cellar: :any_skip_relocation, monterey:       "659f2f4bfb1b13c6782b254f9d177b0eac1b34047a0dd6393edee78483dda2f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c316d93690f0f5859321f46cf89eca8f229ca37ce2db36efe83017cc817bdc"
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