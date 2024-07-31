class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.64.4.tar.gz"
  sha256 "5e7c83c766660d11d6d7a384c6f1a1334b39759b744f9b419dfe28a0547f3a5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "315e969325d7165c7bcc50ecca108d1cdc8c6a58c4825e595f9ea8cb55fc0ea1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2e794d1cd57e499d2aa5225474e67db54aa3b98e85611598f8109ac128011fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90edb63c9be255f2c61a8842b14ab66bf7b1150c3c9b4bc8d5f9e557dba06d6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b95c825e1c8f57432a16e367f1c40fe1b981eeadc5f897cb9e092621f6c1d275"
    sha256 cellar: :any_skip_relocation, ventura:        "b6ff9667be45033f02b9ea33ea3d1c461bbdee3b6adc59f974354bc9355b3637"
    sha256 cellar: :any_skip_relocation, monterey:       "da57a1e1c3ca6c2fa72587d79cde3a2d965496c023d21011ae9a54c22a5899a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28ba0aadccdd263ce00352cd3572397f08249ff2a575442a05831d9a799a2996"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
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