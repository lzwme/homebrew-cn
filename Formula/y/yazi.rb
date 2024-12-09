class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv0.4.0.tar.gz"
  sha256 "65a063705dceecd23cfc3f617bf5e9ec9e31a7e5eef2f9bf4da4ffd4752b5e5c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "845d7b62a7d598f160bc936d26f4950d4cfaa460fbff8df062ec0d3f5d42b6ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f674ad2311f5dad572fbc53eaddf7aba84b2c67154b171cd43139fec83ee207"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1730226cb7d0ee4e575ba27f3816b222c453730847beb8e8589b14f6555990c"
    sha256 cellar: :any_skip_relocation, sonoma:        "52e5832f0ee4d0677f60d41bf32993a25afa4616e5dfae2530482caa1c196901"
    sha256 cellar: :any_skip_relocation, ventura:       "c0663d3f1d4a6c3ce00126668d8405469266506423f837267e3b82a7afa8d2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f3c768bb90b5ef3f423c81e269968d8f60df205c7aa09284b7952183457d066"
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