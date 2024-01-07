class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.74.0.tar.gz"
  sha256 "59469066e2dedc3d0fcc07feaabdfca752c87ff6d14aae653969991e9990e392"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e8b784cf6ce4699ecd590870e72276e5a2fedb4b029cc0eb73f09482dc0af89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d04d0528808c094d79c76cddf35daa5fd0c8cf75bbfdea073e7d32bbbec860e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e0904e92d384277812ff64642b5f46a060ec7c682e256f1cd3f45a3a476aaae"
    sha256 cellar: :any_skip_relocation, sonoma:         "baffb4296305556b8c83bf8301d2a77c9b679a364f786a2beefb6e62704340ff"
    sha256 cellar: :any_skip_relocation, ventura:        "e53d8c699d55cd7057139f3a6d25a10d3742e99c4f6b9cc6c825c19413440220"
    sha256 cellar: :any_skip_relocation, monterey:       "b2732e2e8fc0eacda54a410e4dc8831f5c137e3694361f6397c0106af4896e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3ae61840bd03ca90a117290371d19a6a043c760aa4b2fb92d83dd0b502cacf7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version")
  end
end