class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https:haskellstack.org"
  url "https:github.comcommercialhaskellstackarchiverefstagsv3.3.1.tar.gz"
  sha256 "9a8dc9dd403fa8fd56339353091d438fd5d97ee6f2001a0cc11ba94b19271d98"
  license "BSD-3-Clause"
  head "https:github.comcommercialhaskellstack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b92f9a32629ec7e0985fbd3c36b78e702635c94e3d257e430c31e29134cb88f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fafbac5ff1031862e708ae74fd73868f0240b89cafd8531e5109615a60d2a226"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a4821091488b3a6b1271d0b77bc91ec63960ecc4adb2e04a94ce6ada47e2bc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "10e43c19ccfeddd96f94b53c11bf2997668349031da3b231e1e889907ed31377"
    sha256 cellar: :any_skip_relocation, ventura:       "0c5d5a72df064a4c0df6425aebaf9d2f57a310239e4dbca6f3ab45a0c0a41a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d181279a2913a0f3c6e407cbd860dd1072cd5bd04c24e89f75ced0b1b0a7c3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

  uses_from_macos "zlib"

  def install
    # Remove locked dependencies which only work with a single patch version of GHC.
    # If there are issues resolving dependencies, then can consider bootstrapping with stack instead.
    (buildpath"cabal.project").unlink
    (buildpath"cabal.project").write <<~EOS
      packages: .
    EOS

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    generate_completions_from_executable(bin"stack", "--bash-completion-script", bin"stack",
                                         shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin"stack", "--fish-completion-script", bin"stack",
                                         shells: [:fish], shell_parameter_format: :none)
    generate_completions_from_executable(bin"stack", "--zsh-completion-script", bin"stack",
                                         shells: [:zsh], shell_parameter_format: :none)
  end

  def caveats
    on_macos do
      on_arm do
        <<~EOS
          All GHC versions before 9.2.1 requires LLVM Code Generator as a backend
          on ARM. If you are using one of those GHC versions with `haskell-stack`,
          then you may need to install a supported LLVM version and add its bin
          directory to the PATH.
        EOS
      end
    end
  end

  test do
    system bin"stack", "new", "test"
    assert_predicate testpath"test", :exist?
    assert_match "# test", (testpath"testREADME.md").read
  end
end