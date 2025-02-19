class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https:flow.org"
  url "https:github.comfacebookflowarchiverefstagsv0.261.2.tar.gz"
  sha256 "df5fbc21dcfe0a5a27d223f2426c137367afce646f5f40f0491a8a333fe7f26f"
  license "MIT"
  head "https:github.comfacebookflow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bef81ef6cc43f62385d3d247fb131f2e922038c959ef0a62332f99d88ac13b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb11ce14927564caa4bf82b0ed48d524bf07c21a7a7b8cb54caa8fb2659de53d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "423cd22b7155ca158f65524f8210f7bcb5e07d7199e3bf6718c2faf18c201470"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dcf2c24c4a79216dfdad5ca0f270fc2b52f663946af04a9309b66bd8a495275"
    sha256 cellar: :any_skip_relocation, ventura:       "eaca66abae7912f755eb5913b2b4cb577f0898d0dfd7ba4d83764f125aa3f24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1efb8254bc803cbccab73829b032feffc0ec9cf9b5317447127b8e38cb109ba2"
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