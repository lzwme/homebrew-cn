class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv0.3.0.tar.gz"
  sha256 "0a0c1583accca16759392f258367156a2c36fb0b1d37152b07e1aa5239c531ff"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67952cba77e274b7ff06103464dcf5bc0c93587fb8e77de23e3feed0c4cc9a86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fb25476e45c9a832b957284b2979cf8e39dcc51f66c52e2e1e698b3988d49c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de78aefb2674dac746f19e76cdea3292311dca44969a9bf55e2ba791094959e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9d0ebe7deb747b0d339d8ae8c9bd54677c76a8c43f52468b18ad0e44c170bd8"
    sha256 cellar: :any_skip_relocation, ventura:        "f6387381b81207d9d7951b5fabf5fc969e6ee065a478f0e516f3f8efeb548de0"
    sha256 cellar: :any_skip_relocation, monterey:       "5f9b809d7108a014ae1e503cac0e538c97546b3d356750378300388ab581f711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abc06c1842d16714fb03a4b5ad76786586b45f3c752400fe05343bbccbddfe15"
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