class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.48.0.tar.gz"
  sha256 "5d227b3777fe37fbdc5fa1e97d68bb6a83800b9310ae1789b49a5d4676bd34d1"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "46888b7d793f99c1dbfce5dc6c7dbb12a24cdadbc9517f938a1fc601196f6703"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "46888b7d793f99c1dbfce5dc6c7dbb12a24cdadbc9517f938a1fc601196f6703"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "46888b7d793f99c1dbfce5dc6c7dbb12a24cdadbc9517f938a1fc601196f6703"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "98a21cb5858dd9e49bb354563d196fe2fb78d07adafa67316e82dacbed25e1f9"
    sha256 cellar: :any,                 x86_64_linux:      "7aa84d00243a83f4a383a963f4b0a9fa5690486b561f7b936a1ce9d307a1e5e3"
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