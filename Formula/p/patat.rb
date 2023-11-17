class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https://github.com/jaspervdj/patat"
  url "https://hackage.haskell.org/package/patat-0.10.1.1/patat-0.10.1.1.tar.gz"
  sha256 "f16e93a4199c301ad18fc48d3ae8eb49f6fb64f4550e6629e199249a6dc6ae59"
  license "GPL-2.0-or-later"
  head "https://github.com/jaspervdj/patat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d6900fe10dd8656f91b795d36eef6208a0eec95041630c621d215582557d4f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbee8f706cf322fcb9720c57b3d2399943188fe2fe3bf1cf32c1c957f4b3033a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cd9cec3e872d861bdd9c1e6276615e23087b595fc1538094b7d429837fcd2fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdf23316f81f10790962baf9ff0cac278c608f8cbad9cd8f6ba4f7006423c199"
    sha256 cellar: :any_skip_relocation, ventura:        "f89db63f38080370277a261d5feb7a2e11c417c66bb84c22f6797cece6446aeb"
    sha256 cellar: :any_skip_relocation, monterey:       "c67acd7b903a3ee18bf2d96af4705a9d60618c0db42208b5e4cba8d3c4b0dbc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c09cffeff8aa1c14a900cca33a8053812b196f220be9c38832d409d359c20075"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    test_file = testpath/"test.md"
    test_file.write <<~EOS
      # Hello from Patat
      Slide 1
      ---
      Slide 2
    EOS
    output = shell_output("#{bin}/patat --dump --force #{test_file}")
    assert_match "Hello from Patat", output

    assert_match version.to_s, shell_output("#{bin}/patat --version")
  end
end