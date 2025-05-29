class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv25.5.28.tar.gz"
  sha256 "6d6258d68f3e453be8b9ba966073d52af893149f04c790d6d8fe6f2597e26b4f"
  license "MIT"
  head "https:github.comsxyaziyazi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7393747ac9e178df44146102ed7458d919890bc26d2d1199260dd73dcb307fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22d23824d6bc24cd964cf317ae51f18ee426616c21eae3a1365534bfc990d0c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9837c1382a0751a601c75f233fa8ca4dc629ddc54fe6de96644c07328d7963cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e96e8b3cd66dbc502a1b7e3d297634d7c4a0440b80816a59f0af7b02c07fab74"
    sha256 cellar: :any_skip_relocation, ventura:       "f6c6e73c95a5b7eb64226ee2d574a17aa46c3cd8a41652402579a7e028c7397a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908cb32681d46677e28afd69a1fa4fc2399261f6c86974a48b83134d5002e049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "222e0b8acf14a8a84c0b4c6ce9a2027df66bf5f26b56009ab74b14c158f67fcd"
  end

  depends_on "rust" => :build

  def install
    ENV["VERGEN_GIT_SHA"] = tap.user
    ENV["YAZI_GEN_COMPLETIONS"] = "1"
    system "cargo", "install", *std_cargo_args(path: "yazi-fm")
    system "cargo", "install", *std_cargo_args(path: "yazi-cli")

    bash_completion.install "yazi-bootcompletionsyazi.bash" => "yazi"
    zsh_completion.install "yazi-bootcompletions_yazi"
    fish_completion.install "yazi-bootcompletionsyazi.fish"

    bash_completion.install "yazi-clicompletionsya.bash" => "ya"
    zsh_completion.install "yazi-clicompletions_ya"
    fish_completion.install "yazi-clicompletionsya.fish"
  end

  test do
    # yazi is a GUI application
    assert_match "Yazi #{version}", shell_output("#{bin}yazi --version").strip
  end
end