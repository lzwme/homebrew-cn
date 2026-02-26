class ElanInit < Formula
  desc "Lean Theorem Prover installer and version manager"
  homepage "https://github.com/leanprover/elan"
  url "https://ghfast.top/https://github.com/leanprover/elan/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "451f194ab00395524d3843e3a0841273ce91ac2136bd1ef6f62c7d8f63c3dd17"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/leanprover/elan.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe5bf4830ff487e53a02d5afa3d8af13e1727402263fe60de611b99a5edcde8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c3b4bb4aa9a3ebcb3452ec39c97a02fb632d69380856c60ec00360dd8a4a773"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27bfce3b10497a7df56d8e41fcfc3b80f92f69cee55877cfeb896ee0194246b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b14211f6be8ebc77c0a1294a39e1d0186e9b5b28d664e7abd0d4cce8e5d8a6b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "150bea6fedf58f7439874d62ecee7b797d956e8a9a5e92d6c9690ae9dcfcc30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12a9d025de3fe9ff78a480f2a3ba29f85d029aa28e62b8409c79f8964eb9a420"
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