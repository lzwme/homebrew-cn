class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.33.1.tar.gz"
  sha256 "0bbed0361aba918d7d93ed17d97441e304a5ee264c4b974e88be751dbeb1f715"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc77224e8765386f55559e768d3a33297a393670aa42558aaeb625ffdf8a736a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc77224e8765386f55559e768d3a33297a393670aa42558aaeb625ffdf8a736a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc77224e8765386f55559e768d3a33297a393670aa42558aaeb625ffdf8a736a"
    sha256 cellar: :any_skip_relocation, sonoma:        "45371b014fa71dc4fdca2e4e8f607a14a045ab570e0d0744e439de1529978bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61ae7935b886d5b5c2ac798049eb791f82ee0a332dd05f76187a7147438a20b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f6809cd1ea6773a8559075e75fad07b090536ac9aec4ea59b1cb7a58da5c90c"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"cloudquery", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end