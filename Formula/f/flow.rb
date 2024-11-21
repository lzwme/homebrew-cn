class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.254.0.tar.gz"
  sha256 "fdb5e4bc5b1015b6f72e1a657d3d40125448db2ad6fe33822d8eda515a69377d"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42c1a0215d00d54313720679106f128132dd999df0856d78d8df1b8a671531c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6ec769a02ed01debbd704c579fbb1efbab3ff0e96477719eec197954857b552"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ecc70022c77b198a61e3fef17903faf45b12842cdfd9071b28dea32dfd8c0e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3df5cd7c7478a187c9a993a9e95cb8b5e236b1f8afba96e63354a35fc567694e"
    sha256 cellar: :any_skip_relocation, ventura:       "8a14d2f7f408a338621499b58c5f437e13b16a17a12baee46dba0dc4e28ed42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6857cc7cb74bcd4b1302242c660cd84c1095336ce6523d0c27023b7501cd5e7"
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