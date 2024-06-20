class Yazi < Formula
  desc "Blazing fast terminal file manager written in Rust, based on async IO"
  homepage "https:github.comsxyaziyazi"
  url "https:github.comsxyaziyaziarchiverefstagsv0.2.5.tar.gz"
  sha256 "aea4a6ebd7f56c5d5fe6afbea143fc98c336d4ccd7852f2e8983c23e205988c4"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c8b0ab9f80b5d0ab80672fdac86f188ca33c9425fd73014b3cf9fed62d691d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "821e2333d4a388d4c3b6a59b48364717242eb6c262a09e6256a4ef4e8d4a261c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4858bac34cba74df38d096e60da4eebd0354bdc6fdb8530acc07c1533b6bdcc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5b3658172fb5c0a667cc0c6aca57166450afe6a0bbf71d01ad71de0dbe28eb4"
    sha256 cellar: :any_skip_relocation, ventura:        "425c974caa2e8eb5f8340f5b9027517bcdb40145a2776cdd6e381e08b5c79a1a"
    sha256 cellar: :any_skip_relocation, monterey:       "22d4cc7b2a4fedcbae01feed518365eabfbc9cc0815b21c7a4421e2d52e42e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e0d354fce49bb77e9a8c885a0de4986e71061ad358e4e474cdb40818a33ef0"
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