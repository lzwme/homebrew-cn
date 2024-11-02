class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.84.tar.gz"
  sha256 "6d821888a8efeb5d295cf67e45900f7f919f5684e20a723af6ba41958c4e49b2"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a645dc50f19a8fd409ba1a52db958d3310d10fef41d96163a4172151c5b9f8cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a645dc50f19a8fd409ba1a52db958d3310d10fef41d96163a4172151c5b9f8cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a645dc50f19a8fd409ba1a52db958d3310d10fef41d96163a4172151c5b9f8cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a8552583b4bfea73f69c07a06046afdd8057e26dfc8328dc983b386eac33405"
    sha256 cellar: :any_skip_relocation, ventura:       "0a8552583b4bfea73f69c07a06046afdd8057e26dfc8328dc983b386eac33405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f3907ebe25df35784579e29c3f9f347b351df240b0ae3f27c52f0dedd528bd"
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
    assert_match "ERRO Unable to retrieve account id", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end