class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv25.3.2.tar.gz"
  sha256 "bc1a7b6cd69310ea3369bec2a618e7a0f683f7d25f41a1abdcab82f6a1886bab"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b88d2b8d0461293dbcaed3e1f2f9fc7c94c35d368e030f086afe913f19e6640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "182417738d6c8432c6316e000a0f59c9c98e6304af73dfa2c195ebbcd90c6939"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33b435ac5399ceaea9b037b5f34defec8994a65aaac74fbe1df606878f24410a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf86143b7021f7f767572beb7f3a94923fdad4caab9aa9b0e7e6d96c89992666"
    sha256 cellar: :any_skip_relocation, ventura:       "6cc3ed964ad7c6f5fb0bf28c5082d5f917ef42c565b5611070a21e9a4a605c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f1c53b2c95d2fbfb1d78ed707d7664c377e3a8ac6418a0d7db4d7924e98d01e"
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