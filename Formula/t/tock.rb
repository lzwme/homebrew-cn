class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "b39e81340b7c02f58735c6023368c548ea9acffa534da5ef90b24d7fe8b6108d"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e33228c3637dbc5d1c24e671a73e54505e1cca64393ccd6fbb14e5a70a9dd05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e33228c3637dbc5d1c24e671a73e54505e1cca64393ccd6fbb14e5a70a9dd05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e33228c3637dbc5d1c24e671a73e54505e1cca64393ccd6fbb14e5a70a9dd05"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b087f5cb21c68d7b731a650824d0cfdd4773ebb462ebc7cfa2be277468b7bda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2fc16322249606f40b41fc6f2081f8eccf9c4d97b03f433a7f472c1a5a72f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6379078f39abb8851d5e7fe5cbfe664f7f80d7bfae00b429b44fd3f3d204513"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end