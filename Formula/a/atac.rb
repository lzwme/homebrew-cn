class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https:atac.julien-cpsn.com"
  url "https:github.comJulien-cpsnATACarchiverefstagsv0.20.0.tar.gz"
  sha256 "2f1b7cb1eae7aac4e5fd39a9d87eeb27d3c3167695c9e4af1dae3906172d0f57"
  license "MIT"
  head "https:github.comJulien-cpsnATAC.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "59bc7fab0781c4deb73356174db8a139394f2b5cfec0bb5b3a039b901885f224"
    sha256 cellar: :any,                 arm64_sonoma:  "9e69fed7b6b3752986523b6dbf31f2f3ca4e377881a682ed28147fa5c72a3217"
    sha256 cellar: :any,                 arm64_ventura: "7436aceca7891c5f421e2b7c0619038a2248fbdd237f3a77feea08df246b364b"
    sha256 cellar: :any,                 sonoma:        "8f1fd657ca6c5ebfaa02b1dca032cc049a930b8b390811721976ba051ccd88ee"
    sha256 cellar: :any,                 ventura:       "9e69a9fdfd01701af363a43715e1e2431746064f9f07feae807fc957d19018c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e0653d5ad931c62d9a7dbe6419f68446e29b2e7481d1e782afd06b635b6e15f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5c8ad00161a566c3fcc3d7fb40460c430147324e874b313c4c1091226ee055c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args

    # Completions and manpage are generated as files, not printed to stdout
    system bin"atac", "completions", "bash"
    system bin"atac", "completions", "fish"
    system bin"atac", "completions", "zsh"
    bash_completion.install "atac.bash" => "atac"
    fish_completion.install "atac.fish"
    zsh_completion.install "_atac"

    system bin"atac", "man"
    man1.install "atac.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}atac --version")

    system bin"atac", "collection", "new", "test"
    assert_match "test", shell_output("#{bin}atac collection list")

    system bin"atac", "try", "-u", "https:postman-echo.compost",
                      "-m", "POST", "--duration", "--console", "--hide-content"
  end
end