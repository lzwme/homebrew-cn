class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://ghfast.top/https://github.com/babarot/gomi/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "d29a2ae63af5bbdda184e1ee7f513244f70c4111aad68cfd5f6e2edab572c006"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e3ab1122bae1b2fcd40acc84c3f92c20890f15bff539b685eb1e5a2c8b32d942"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3ab1122bae1b2fcd40acc84c3f92c20890f15bff539b685eb1e5a2c8b32d942"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3ab1122bae1b2fcd40acc84c3f92c20890f15bff539b685eb1e5a2c8b32d942"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ace8e933ceaca6ce51487e4685850f5e03925fdeef160bf77ce7e364d531be72"
    sha256 cellar: :any,                 x86_64_linux:      "df191b6ce7174bf5958c33794342bdf03c73f8a3f36034e210364168b79344fd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["TMPDIR"] = testpath

    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}/gomi --version")

    (testpath/"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath/"trash"
    system bin/"gomi", "trash"
    refute_path_exists testpath/"trash"
  end
end