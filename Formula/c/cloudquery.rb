class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.33.0.tar.gz"
  sha256 "30720968d68cfab0983af0c8034213ac2d5fb0d4d91e8abd11fef23536005c39"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1da5f393a989dd3a07b0d67ebc15011b1c8e30d1427a17a3b9007076874f0b43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da5f393a989dd3a07b0d67ebc15011b1c8e30d1427a17a3b9007076874f0b43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1da5f393a989dd3a07b0d67ebc15011b1c8e30d1427a17a3b9007076874f0b43"
    sha256 cellar: :any_skip_relocation, sonoma:        "225726ffae250516acc02c2801e8ffc26b17f121b5b4a8c5815a0ea36d2d38d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0037785b245c7816da0537a3adb84d2ef7c9a5c9cd3335b933da8739f6e320c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc77657f1544176b8c055d809b501b60d002d2ee91a7b8f301dab122fd4f161"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"cloudquery", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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