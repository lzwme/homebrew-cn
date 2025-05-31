class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv25.5.31.tar.gz"
  sha256 "4d005e7c3f32b5574d51ab105597f3da3a4be2f7b5cd1bcb284143ad38253ed4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55ae93d2fd850112f783f4052e4246bdc0d978717bf128afffaee1386c367fbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f068f0631c6431fd36de113d88875a0ac10875f6cabc08f19251cab578a6fa97"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66a6dd96dd47205f720454d129eb74bd483137f7aef9c166f4b041cbf045345d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cba596dd9ee6335a7424596fab979a3845877c87fb3bd7b3259b30f11e17517"
    sha256 cellar: :any_skip_relocation, ventura:       "1b00c00a1d6ebb2f02badd0a37610674ea71e7f954fcecdec2568e58e3374709"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8abea4a36aaa705edd6ef655ce3d24fc58346ac1ddf041e85589b2ce352ed23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "961112614f3d0ec7052085aa2208e299cdf00002454c04777ef703fd5eb38837"
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