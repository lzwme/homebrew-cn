class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https:linuxcontainers.orgincus"
  url "https:linuxcontainers.orgdownloadsincusincus-6.10.tar.xz"
  sha256 "f4a92cb74aa19ec7c71043023423f7c1ad82e453bdb1a95ee754212167521400"
  license "Apache-2.0"
  head "https:github.comlxcincus.git", branch: "main"

  livecheck do
    url "https:linuxcontainers.orgincusdownloads"
    regex(href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28dbdd9cb3e73b261e1e8d42491c30a1d0c9a76abb376383386fb3b9e5d58dfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28dbdd9cb3e73b261e1e8d42491c30a1d0c9a76abb376383386fb3b9e5d58dfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28dbdd9cb3e73b261e1e8d42491c30a1d0c9a76abb376383386fb3b9e5d58dfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b54551277182731f8679aa42d0ea38680f80b069e23966f9146220e47b4160a"
    sha256 cellar: :any_skip_relocation, ventura:       "4b54551277182731f8679aa42d0ea38680f80b069e23966f9146220e47b4160a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d56a68ca0e39453fecba530d9091a3c365bbc95ad91717ff628fc0e24ae27d0d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdincus"

    generate_completions_from_executable(bin"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}incus remote list --format json"))
    assert_equal "https:images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}incus --version")
  end
end