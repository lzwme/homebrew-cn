class Devspace < Formula
  desc "CLI helps developdeploydebug apps with Docker and k8s"
  homepage "https:devspace.sh"
  url "https:github.comdevspace-shdevspacearchiverefstagsv6.3.13.tar.gz"
  sha256 "73f89a6715c86619711398501c5235a14a98b5ade8c27a0b5c890234e2a5c218"
  license "Apache-2.0"
  head "https:github.comloft-shdevspace.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34d15372ea660086ef8070c7acd50c804e08e14c3e4278d851a6f638dd3faaa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c17bccf7eb1852ef06adbe145728d46024b809ef1035394af8ff9b024e51212d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d324abf777f1a09e47f485494d5ef3e3588b6bbd205b7002b4a26c544bff020f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b605f1570a2f22030f6c221db03e2a5a4fe6c457891def0632a9b023c199e1a"
    sha256 cellar: :any_skip_relocation, ventura:       "2e591d843ce559d153b048c29e54a623f12297708bf755cfc6fd149cd20c0229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7f46300dc5a8043c58a5e162a7457a2653e3d1597ba23c2dbdb7fdc630a1e66"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.commitHash=#{tap.user} -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"devspace", "completion")
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}devspace --help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}devspace init --help")

    assert_match version.to_s, shell_output("#{bin}devspace version")
  end
end