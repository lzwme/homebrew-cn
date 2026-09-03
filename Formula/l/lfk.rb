class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "fcd18bf8f26239cbed1720508c252bf053e32c711968926ca166ba29b7ffb6e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "789eb06083bebf8eae2fb0ff05242bc0089038278b226f4c0f808794cbcb2e42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3b47623bf6b9d4e7d0f437abb982ecc3449377446ac565575ff202a477172cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d90a8fdc7b5b432c7374d97f57f24880ff633a76605d608fb05302dd6d2198d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "083c21ee5bcd31d67c665b11f256ac29c8f0d1af243edeecc2bdd91d2d3731bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4988447146a2dd192286947af0ce6b02620e0109d22db338ca4e649b8a41120a"
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