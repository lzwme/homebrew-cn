class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.228.0.tar.gz"
  sha256 "e16b2c7eb55a8fbdbcf2cc3e482642ce70550abb1858420a1876eefd293faf77"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a4084f6bec70085e5ad231899f8d282b3050bdc36abda980acd6b9381758ff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b8a508dc994bfad8a10a83571060be494e20687c4865296f136750a552d3a35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fdff69887454e5a7c58f06abbea4f8872b79a57d78557daa83e8d697d56966a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea4f820e7683b59e712cff1a45fcf4b9108d95b6d79847ec8f6e8f34fa743328"
    sha256 cellar: :any_skip_relocation, ventura:        "6bb0234ac3ea7a977ca76a42de2ed137f3a77a64b160f79d8af8b8417b391cc0"
    sha256 cellar: :any_skip_relocation, monterey:       "f2a10c3905f570d64161dc1d117609b1ba8fa74ac1d92c0b18325f5998254938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad2641c0d0e8df51a37e1c9a1c88f194f0e230f33ef75584f29023faff27fa61"
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