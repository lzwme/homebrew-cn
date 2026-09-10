class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.10.tar.gz"
  sha256 "3b0b48a46e952f1bc74ec2f2538273f9f922aaab3923e262e0077215ecebbc1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efaa5deb4340e89915ed71734e76e536868edf30f642b22dd90eee43d237cfea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "511dc2376592fbf4215dbfad1d28bf36d75247661375e1de8c315507e717f8d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "133fd9898732c750d08438e43130eb61ea82403e44acc54a94c591961c4a2691"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff702b4a4cfb50236a3337e6721af11a50a4dd9f9e74b7c0fc22f037d70b63f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "404f9f09285d4569ae0672e67fb082bf0f67082169a4c3cfe37468c0cfbf266c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end