class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https:gomi.dev"
  url "https:github.combabarotgomiarchiverefstagsv1.4.3.tar.gz"
  sha256 "8026dbba1f07a67b20c7a2ffa5bc7514da888a5f64a9fc11dde54112353a8912"
  license "MIT"
  head "https:github.combabarotgomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d97e4b9abe9e07847f0365360d4a6fab8c34177a2e57b452511c73354787c92a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d97e4b9abe9e07847f0365360d4a6fab8c34177a2e57b452511c73354787c92a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d97e4b9abe9e07847f0365360d4a6fab8c34177a2e57b452511c73354787c92a"
    sha256 cellar: :any_skip_relocation, sonoma:        "62d768b867c8abf14ff3bd71c13e290f54af143c949cec51fcfb054c10e36c61"
    sha256 cellar: :any_skip_relocation, ventura:       "62d768b867c8abf14ff3bd71c13e290f54af143c949cec51fcfb054c10e36c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d6ca2b7e9cb1d6062f025371791fdada6adbf7ef7e27b49a383c7bcb3a00143"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}gomi --version")

    (testpath"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath"trash"
    system bin"gomi", "trash"
    refute_path_exists testpath"trash"
  end
end