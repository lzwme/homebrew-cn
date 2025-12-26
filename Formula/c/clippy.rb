class Clippy < Formula
  desc "Copy files from your terminal that actually paste into GUI apps"
  homepage "https://github.com/neilberkman/clippy"
  url "https://ghfast.top/https://github.com/neilberkman/clippy/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "273dede89fa4e71e89e08110e2fa311e6113163200a729b10fa4bae7438e1734"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc4818dc67086abcc5d9f07401c6bbf17bbb17268811e9ef591f9bec53980140"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f6bff895d3df850e33cef0d1577078f5a38306513c79da9cddce0438448460"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c8e3f2299ce2ddbf96e7027ae64b8611d5e3bea58a9603726586ced45ac136d"
    sha256 cellar: :any_skip_relocation, sonoma:        "375f0956e1e808a0fda35e315c0f341faa70d73925fcef1e1e3855b3aa49f099"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = %W[
      -s -w
      -X github.com/neilberkman/clippy/cmd/internal/common.Version=#{version}
      -X github.com/neilberkman/clippy/cmd/internal/common.Commit=#{tap.user}
      -X github.com/neilberkman/clippy/cmd/internal/common.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/clippy"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pasty"), "./cmd/pasty"

    %w[clippy pasty].each do |cmd|
      generate_completions_from_executable(bin/cmd, shell_parameter_format: :cobra)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clippy --version")
    assert_match version.to_s, shell_output("#{bin}/pasty --version")

    (testpath/"test.txt").write("test content")
    system bin/"clippy", "-t", testpath/"test.txt"
  end
end