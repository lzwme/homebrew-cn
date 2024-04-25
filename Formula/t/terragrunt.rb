class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.57.9.tar.gz"
  sha256 "69545ec71b15f84b636c2a4b5daa19ff268ce36f5adcd23387d5e9d038dadcee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10425eb8a42a2c87ba1cb315e1cd5e37ef6f13c6bf972ce61f54d940a7995c0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9601de2e8e1ce7336c00cf1e9d7a015eb5470b7a916cf29a233a9d76acbb585f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b181f0afbcdaed9a54725022770df3f9a8eec95c34c0e047c56b28c5bb529646"
    sha256 cellar: :any_skip_relocation, sonoma:         "53ab568b1b9208d23ae01a71898081a464c385785f089d5e4df4566dedc48089"
    sha256 cellar: :any_skip_relocation, ventura:        "b3d85a406479c0f091d2691c73aa4276fe3fc7aee783594ecb9f332061e6708e"
    sha256 cellar: :any_skip_relocation, monterey:       "40caad8939f56eb79cf259c743a6735e74a13670446ac309470fdcda796d5e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c461740c12af784533fb3d9e9862596919fe01651710e00195b4a5a611141e2c"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end