class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.70.tar.gz"
  sha256 "91c5f798eab6078cda5ebb980304cfb2b33f5b493f0119110709f80939593ee5"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a32c8e11422435fff5f6b657de96033c32a457795cf6837232003aef545346c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a32c8e11422435fff5f6b657de96033c32a457795cf6837232003aef545346c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a32c8e11422435fff5f6b657de96033c32a457795cf6837232003aef545346c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "74861a6658c99a5bfbd5357a7a5bc36f04922e0c7556f178fc525239c5a51555"
    sha256 cellar: :any_skip_relocation, ventura:       "6f6054014b1943a735f46320d3024ff40c5b77f7f0a8b2c5f814c153c6ccee85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89e29cbf9e0d4620f05c573eeddc95114720da66e04e170a7029672d300d76ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commindersecminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end