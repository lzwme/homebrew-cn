class Tetra < Formula
  desc "Tetragon CLI to observe, manage and troubleshoot Tetragon instances"
  homepage "https://tetragon.io/"
  url "https://ghfast.top/https://github.com/cilium/tetragon/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "57c9b83c87957718d16bd711469f15fde28e383af6c84d4133a0a5423e6b9267"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0f19b2a1bdd0f78fbfb9d69b97e7bb3697c274a6167fb8eec43a6e349fc65a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "317193bbcc8d7c878b8e1af70147f6e1fb009e5f8d50c847c78af31b900cab04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82eb8cdfda8fc03a660fc81e1522cb97cc2f5e8bf2301b1270cdd6d0dbf3719e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff0b203131ca6caa46fe4cea57aebf45d2015d3e74f65584fd4f4a65f56a6fe5"
    sha256 cellar: :any_skip_relocation, ventura:       "1d4794279c864c92757c8a33a06eb7ebba1840757106adf7114c8a8d4796ed09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "942a420637a79fa7e3a62ee7b60b7cf8ff8b529222d56f9a5c1b9f2e0cac38cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/tetragon/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"tetra"), "./cmd/tetra"

    generate_completions_from_executable(bin/"tetra", "completion")
  end

  test do
    assert_match "CLI version: #{version}", shell_output("#{bin}/tetra version --build")
    assert_match "{}", pipe_output("#{bin}/tetra getevents", "invalid_event")
  end
end