class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.96.tar.gz"
  sha256 "b5f0d11a6eda3fedbe4f395a20732d3e664d617bbeb97178ac8e2a86aa5f9388"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5053f27f1fbfd93d38064912716b132e29430d4e4780be03b1aa010adfc85ced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5053f27f1fbfd93d38064912716b132e29430d4e4780be03b1aa010adfc85ced"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5053f27f1fbfd93d38064912716b132e29430d4e4780be03b1aa010adfc85ced"
    sha256 cellar: :any_skip_relocation, sonoma:        "b707f1b28b114f0575efc57ee364b9401fa48d9fcb44ac6b7d4591ae1181d1a3"
    sha256 cellar: :any_skip_relocation, ventura:       "b707f1b28b114f0575efc57ee364b9401fa48d9fcb44ac6b7d4591ae1181d1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b7e443c49bfa8f7bcbc1582fb52cf778caa3e59b611386564cf0070ff6aad2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end