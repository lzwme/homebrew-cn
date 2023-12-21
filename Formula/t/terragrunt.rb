class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.9.tar.gz"
  sha256 "f9ae77f28da514574ec408115f0d82bf539150e6791dff8c6e740d28aa845292"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39076627b1ba2a01fc4d35d1ef5390d1d2020507259c1e0517e59d35fd169501"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc50885adbbd5ad525d49a800f00a6d332f2ffefa3e79f9b0fdfdd773ae2a5f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c1c883e06207b2c3b448d8d520d57e97db6e87856e60d4e32ec79b6a2e63fe0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f84ffa9f80de1e7c7d0b557feb39ed24b0e4471d5809ab6ec534f68eecdf040"
    sha256 cellar: :any_skip_relocation, ventura:        "be623365a6c6c4937d920aebdd73c6d7a78812a319b82788dcda022eeb4772d7"
    sha256 cellar: :any_skip_relocation, monterey:       "5947c67eee85669b457c462487b769e48bed816ffb8f69e4dcf4827e11576402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4915d004a45d44bc41dc05e42b34a12f72059a178452257b1316181fff3d695c"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end