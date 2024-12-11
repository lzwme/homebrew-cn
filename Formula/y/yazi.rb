class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv0.4.1.tar.gz"
  sha256 "702f7f7b69248d8e2bc2d75c1f293d6c92bad4e37a87e5e02850ba44ece44e2c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a7d804579ca90d26b9e7d93579e85b81623a5b1f28a7ab49391129ba332dee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c0dd3e0aa54d07cce1dcf4c4e72a684977a0b9cd6a82ac619a7f23dd9550b8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87bb311473212cc9caeb2f4cf01d35a7aa8cb630310c288db8ae3c58a9e8d7e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c8a100bfd2ae6db2340726f1687571a4ad8b8a1d866c546373054c4e7102280"
    sha256 cellar: :any_skip_relocation, ventura:       "8ac73977994fe8ec4da3f0e2d352148e8f42dee32383e206faadc2e32c6927bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "674f0dfdd8a598b9dd2af7a44e415fcd8b17a8169e8281338276c5087d7536e2"
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