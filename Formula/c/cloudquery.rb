class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.27.0.tar.gz"
  sha256 "aa692e53a1c2d2f1161c2760f324ea3dc3646a14cf4de91c87c0d9da8b307632"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb6d40eebbef448cac1f1629ea36e598c2932342f63c65aa37ccc25d632ab386"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb6d40eebbef448cac1f1629ea36e598c2932342f63c65aa37ccc25d632ab386"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb6d40eebbef448cac1f1629ea36e598c2932342f63c65aa37ccc25d632ab386"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c5e89263b7ddbb351190bb0c028501497cb6c752deb273172d6a8f884233324"
    sha256 cellar: :any_skip_relocation, ventura:       "4c5e89263b7ddbb351190bb0c028501497cb6c752deb273172d6a8f884233324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8b5091a519777acc5359d6cb160bd73fa2773b48a0d9ff294bada4b8a597a0c"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
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