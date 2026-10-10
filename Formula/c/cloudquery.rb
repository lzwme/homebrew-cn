class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.47.0.tar.gz"
  sha256 "6045f20d300519e61c50db16000877eac50e8da97e8aa1072e3f6d8850520ced"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1679b6c2ce02b58a1357dec7d750f9df68e1eb3ab43bf2db469a6afce45de949"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1679b6c2ce02b58a1357dec7d750f9df68e1eb3ab43bf2db469a6afce45de949"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1679b6c2ce02b58a1357dec7d750f9df68e1eb3ab43bf2db469a6afce45de949"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6b4545ea8197e95affe387e3b64fbc25ad17eb4f6f6e0241d89c2062086298f0"
    sha256 cellar: :any,                 x86_64_linux:      "10a384283d9a6f92268444a94e65a00c202d8c11faa9a50fc8db97d498e1ae42"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "cli"
  end

  def install
    cd "cli" do
      ldflags = "-X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
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