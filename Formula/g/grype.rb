class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.81.0.tar.gz"
  sha256 "fafd56f0588d779af41c17efb7a5d239c2e68e183ecd2d5544936e8272662b5b"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccb5de29437b262b8177de184608715e738fdceb1f47d6ad40f1f7cd63e7e1d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98d37f519ad4eabe93dc0cdc69c0dcd0e1e8511eeb6c970d09b354e4951eb854"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8e666d2dcc020ce0e3c1b9cf5732aa21c7d848b229990509c75f52eeed9b7c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cda0aacfa6448bf36d1831cfa3bba2f7f7363864e18c6a3e16d876559bfaa39"
    sha256 cellar: :any_skip_relocation, ventura:       "896639e1292a3bbdcac9efbe0a96a99c7384c98115c51baa33b6b12bfd6ebd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57822474099b11a9ba065a99613b2b36d3309df5d31be7e725f960d6363ed388"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end