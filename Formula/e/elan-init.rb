class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://ghfast.top/https://github.com/leanprover/elan/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "b1f151659be6f2a9c840049ec40bff126847de0fcceef7c42da04627e34b1712"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a90893f8379a0d4ed86b5221ceb9f695c4d02cc3119f4fcfeb9040a49335945"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd6cec38e28d57af748a4ca5448d569ccb98f21d9b78d6cb4e037d974434a54f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e87d7ac0d97409f6b56a459bbc5f8f129886132d3a9c91e51771b4c784a6ddba"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cf1dc6d52084d03f5925c37a0024d7200d5a12d2ad2c76067ee48274f7ead7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35070ba93d6f92605c4cc92a911811b599e5683befd4a89a1fa77d5842f61db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1779d9405be3a6603585061405937fd2de0001e595f3caac78aa376c1bfb6a96"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "coreutils"
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "xz"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "lean-cli", because: "both install `lean` binaries"

  def install
    ENV["RELEASE_TARGET_NAME"] = "homebrew-build"

    system "cargo", "install", *std_cargo_args(features: "no-self-update")

    %w[lean leanpkg leanchecker leanc leanmake lake elan].each do |link|
      bin.install_symlink "elan-init" => link
    end

    generate_completions_from_executable(bin/"elan", "completions")
  end

  test do
    ENV["ELAN_HOME"] = testpath/".elan"

    system bin/"elan-init", "-y", "--default-toolchain=leanprover/lean4:stable"
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree {α : Type} : Type
      | node : α → List tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a := by
          intro h; cases h with
          | intro ha hb => constructor; exact hb; exact ha
    EOS
    system bin/"lean", testpath/"hello.lean"
    system bin/"lake", "help"
  end
end