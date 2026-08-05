class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.15.16.tar.gz"
  sha256 "16345459778efad67dd2e9ec8b60b88ecf99d5b7077b89835a9b484729cf7943"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "872dad8badea3105b5793624b49af6f1e3a87bc63e682181156ad169976a2bdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0f212b84582d76e51b8e021c7948ba3fda99bd90038b662e5b0f0786f22a912"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47ea52aa3dc01b2d567956923dd403f7ebef2d2315ad8685fbe6e11ca371b62e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f62d5dc140959f1060df4400a740507d5d70889d1ad644d4d9c515d15705a080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beda6a7c37d4bf8cce4357f98049a35e1f60712a69e4d4f8847c77179db1ecaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ab8ad4312060cf55d6b6f2531d781d4ea527199b5ae1ada515128f60ffac68f"
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