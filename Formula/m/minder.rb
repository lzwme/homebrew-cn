class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.86.tar.gz"
  sha256 "fe96ca6d9867cf23ce34f987d28880094961674e3db4a59a9d636acca84a92a6"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ad5ea38f552aed13d50342905edd6f0cace0998d306447ed32bca96589e1a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ad5ea38f552aed13d50342905edd6f0cace0998d306447ed32bca96589e1a73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ad5ea38f552aed13d50342905edd6f0cace0998d306447ed32bca96589e1a73"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4f8231ef0435df27fef76c42e87227be7c4c1f7add6c58e3830dc634968ea80"
    sha256 cellar: :any_skip_relocation, ventura:       "4d0f1c3f3da51f10c7fcec08dee1b76163575d51268cbb9ecb85decdef95d862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "549af2938ca65bacf081e508ecef4e982cfa05375f2c6dd12875f75fa605a939"
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