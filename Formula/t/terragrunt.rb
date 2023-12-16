class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.54.5.tar.gz"
  sha256 "b3530c68a704a98e1f7b3e7bb9a5be567ec82f6030470686620d3978d42722c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7deafe96824be97dfec47e72f3208ef8051656c253a67e9e54c0a6bb9c9c484"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "522cf297034e9640382c6871e92887ef880f260b77a840eff14af4a7d0f90045"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9803782519e67c862b686eeef215814e4070b1644b3230d38933a857ff1193c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e1dd052614c2ea10aa209e94d96d064baa564b25b47092d36003f9154a8518a"
    sha256 cellar: :any_skip_relocation, ventura:        "21198cb9f6817d8953a3a414385aad439783350e2b8a629dc6032dfaadd04ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "c44aaa9e4febff1ac12a89048d532d6d201fdc3128b119f70ecca3e83dbc47e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eff76d677d6b9666fa9eb8919dfedb68b38ae5f43d5269130021104ffd6f541"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end