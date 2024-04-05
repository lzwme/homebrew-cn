class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.5.9.tar.gz"
  sha256 "cec1d30a4fae2572cc33666ff90bec464421bbe1ea50dba260135065f1056a1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f70b62221e84bbd9547270e61a48892458f00649fac1baae9cb57313b489ca96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fd062ba68641277ec57f73741df49fd96fa1833e989725424a462191e677d08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "945b2f8ed1581770bd388319ab013eaaa06d8c5f074aedf7780610af0d23395f"
    sha256 cellar: :any_skip_relocation, sonoma:         "360c6f82aa7d64b0376712c08558d9c38bd43d27373a63677c1dcd353f5d03aa"
    sha256 cellar: :any_skip_relocation, ventura:        "94faae313185a58223f31d562033d41fa9d5ad216d198b112471d46ba48b799a"
    sha256 cellar: :any_skip_relocation, monterey:       "de3fb31f4f7ac2d1e64b9cf2ef4aee1d57aef74f676051d6250e9f62f4eb9fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a8e2d493c915c88d4242dd6aa5d68726fe1afd52581ce801a780779fe9ec6fc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1", 1)

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end