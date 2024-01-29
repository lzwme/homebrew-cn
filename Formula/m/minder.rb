class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:minder-docs.stacklok.dev"
  url "https:github.comstacklokminderarchiverefstagsv0.0.27.tar.gz"
  sha256 "1d8e1907e996b009f9222db82a9eee9b9d248ec43021b6e2441f348a83f6af37"
  license "Apache-2.0"
  head "https:github.comstacklokminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fed7932ab68b62d2f022d7c21a4eb3086433e77687a9c6680b7e4f544463aa03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78da0a4893a18ea560a7987d7141c11eec42d58503fb0e296bb08e3964c9197a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a5051c0a5523ada851a5f89cf41a501ae70217e1fc67176a336cf4ca72f1c16"
    sha256 cellar: :any_skip_relocation, sonoma:         "30b08bf2bed7d1a9e0647c38d3302caa613dc38e7fba08161d73a8bb164ec630"
    sha256 cellar: :any_skip_relocation, ventura:        "7e64ababfb7ec87c67265ce349533b42e5299a72823efca2fae78f7d3515ef8f"
    sha256 cellar: :any_skip_relocation, monterey:       "c60a06008139d221172ece83d69b477bbf9e6fdb9fed024a5b3b834a69b49c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40d14ee8422ff6c259638311445848f0b8a3216ff430084c1230fc65efbab0d2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstacklokminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end