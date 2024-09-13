class GitSizer < Formula
  desc "Compute various size metrics for a Git repository"
  homepage "https:github.comgithubgit-sizer"
  url "https:github.comgithubgit-sizerarchiverefstagsv1.5.0.tar.gz"
  sha256 "07a5ac5f30401a17d164a6be8d52d3d474ee9c3fb7f60fd83a617af9f7e902bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ccae14c242e55c103e138e715a48f7a1c7210ce2c749dc18635a60386ccace44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7436b19c338834afaf2a042ce8cf4468a1bdafbe20175caefca0ef69fea2fbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6d81ce3b3553755497bfc41658af2f441ed1084c03ea8a19812f665cec082ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f996c81d0b80e56313f6c187b498c5d3c71001bbac8bd704fd30e5f59c593d67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28f29227982128a8cd544fcfc1d0aa8425f8ec0d9a60ca601426de8050e7a727"
    sha256 cellar: :any_skip_relocation, sonoma:         "a57a2c9483b5b93d414a5bc8d5532832c5d165e5d9349b12d9d6c6ccae052d71"
    sha256 cellar: :any_skip_relocation, ventura:        "84eec3e5aeb0f702b96dc0e15c002a99f46fdf9899e445384a416d1b02b47ee8"
    sha256 cellar: :any_skip_relocation, monterey:       "73f48a5d03c1e8b6a113a1d8509a35b4474bef00c26da7ec592f2c835e77d77a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f52d03752efdb2a0a66e1edbaa87f11c66d953a5338ff84e5a8db8103d84ab46"
    sha256 cellar: :any_skip_relocation, catalina:       "f1af5d8fd18305bf7fc2111435185569d0d113c9437a89d705f9b8c016eb1339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a866d2f5cacd29a14bee3055f3290500091674fb38703ca75eb4c34917cb8ce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.ReleaseVersion=#{version}")
  end

  test do
    system "git", "init"
    output = shell_output(bin"git-sizer")
    assert_match "No problems above the current threshold were found", output
  end
end