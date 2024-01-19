class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.74.1.tar.gz"
  sha256 "86a1bfd493bd84388575617fcf944541cd663df4cbd9ac862e80b7a5846c47df"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c00cb293c0ec801b51b7318de6fe7a0019aaf511fb0c58c7fd6128e6286abef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f3ef702cad8fed0d6cfc7573645d7bbe2d9d0e799eabf1adc15c27cf5200f4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6c97b86d141bc937338328692b89ce55bdbb42deaa55dd9fa7d71e5d50a4c41"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec388f630db783772943f36f16e21512478acd6f7dff2963a6725629609c0574"
    sha256 cellar: :any_skip_relocation, ventura:        "a3adb7c1923b7df56a76c9ce9c9f5e553191aa448016132d8611b20d18402240"
    sha256 cellar: :any_skip_relocation, monterey:       "9acf94f56b1d23a352ddd74a1c74ac3b3c9405c1b48a127bf80a2adc08af014e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bca8d86e4490bd3eba5e3073b41ca4e276e139fbbab933db75a2e40d36acf7dc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version")
  end
end