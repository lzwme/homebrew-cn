class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.85.0.tar.gz"
  sha256 "b32d158629a16a03b4300e48369e0727cb664b3c3652477da3eafab5f1d32931"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "725d4a093a1d21e48282c9005ea3589475b4557307c7b05e744eb6248d8f28dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7b194076a3e275ae470c84b672f12df7feafc7abf6d2b27a58e488da8cfcc69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07376330f471a578c1b150dfb4ad9595802ba01199e5cf53bafe2d1744bb21d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "17e491458c38dc0a51d730b5ef54abaafd522d6c39d3b2079c63595d1b959c5d"
    sha256 cellar: :any_skip_relocation, ventura:       "43da4ed8d22e9951a57a05923643f4bb2d7db974a78c152540bbe92c2dd258e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "891ee483a083705842c3587bf11c962e7361ac2cb17bc931c8b36cc15211b76b"
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