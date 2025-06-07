class MinioWarp < Formula
  desc "S3 benchmarking tool"
  homepage "https:github.comminiowarp"
  url "https:github.comminiowarparchiverefstagsv1.1.5.tar.gz"
  sha256 "4f5dcc4b1b77ff5cd2bb2269cc09743030eaaf60e0d43c4405b57c943272947f"
  license "AGPL-3.0-or-later"
  head "https:github.comminiowarp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7035c94aed3480786063b587da27acfc55c07cdee7fb6b4deeff39090001fca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e23203873a5c58e3ba0b3ea84991b22ec3c3bb3fdbc85d46a2c80a693cbd55c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99f03443b5bd3df6f9970da3534801ac5e8bc0c1508f6d5a16d0b8a9933ff2dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "686545db7929b3aea8d7aa4cd72245db9562aecaa814c7c08fb61f12f15b34ce"
    sha256 cellar: :any_skip_relocation, ventura:       "c852e739e072847d66c85f25a73b2194350502c5a62d56a46bbe7644306e3aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e51c45cf9fcbd180b03052b31abac76a38343969ca1d5a5cd7de544ea67b9fcd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comminiowarppkg.ReleaseTag=v#{version}
      -X github.comminiowarppkg.CommitID=#{tap.user}
      -X github.comminiowarppkg.Version=#{version}
      -X github.comminiowarppkg.ReleaseTime=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"warp")
  end

  test do
    output = shell_output("#{bin}warp list --no-color 2>&1", 1)
    assert_match "warp: <ERROR> Error preparing server", output

    assert_match version.to_s, shell_output("#{bin}warp --version")
  end
end