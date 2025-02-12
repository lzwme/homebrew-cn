class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv25.2.11.tar.gz"
  sha256 "d3879b85465e036abfd69c53488e9bc90c9ad52a31080511a0fcd1b11f81f10b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d571bca833d1939f5175d44fd82e12916febacbb9dd556cf865016ee4b40584"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "513291f863e16f702e65b45370f8042348b0b4900c7ae5f851da6c07b9b58bc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06c7ead29db712de1bca78ad1d00262a230201b2516dc8d720e5a3f5dda501b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "788fa0204b13d072af4b1431e424373fedb84a92aa5fe0d25fda32644cc483b7"
    sha256 cellar: :any_skip_relocation, ventura:       "7d2e683f3ef04866188bba0625cfd04fca10fa1741b0affc7f8e4534752f9aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89f9aa23e9d02cd8c89e632a93872d9b4a5b6786b0a07785fba9554f9f86b280"
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