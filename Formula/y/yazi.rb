class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv25.2.26.tar.gz"
  sha256 "49e1a0fb4e8b4c14c1e16e4b4c9bc52302a5ea7104605f3408c3ab513c3a4869"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2a4d42d63c9c0631741d606d79318bbbb928f1ac9c24614eae355157a10adb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71012f2784f213310d26cbaabb9f586d43ae60ebeca62783a83a8b0531701824"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ceb2929f0863384292eb68477a6800d61187e05b538c592b9fb972c0a2508b11"
    sha256 cellar: :any_skip_relocation, sonoma:        "0afc618f4197e52082659c05d513f25a7155d335c8e4a28c1c476ce41283390f"
    sha256 cellar: :any_skip_relocation, ventura:       "299136afa9a1551fe6059bb75a1841fcb886f96d7f30c6fdfc2376848afddff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1750cc2c2b37f2a290027e2049c9ea18bbc3cf52b1b674fa9f5b7301f1c20299"
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