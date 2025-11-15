class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://ghfast.top/https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.30.3.tar.gz"
  sha256 "77182a1091d6e68277f95e60993dda7de60d705c041920cdd3878f27ececd2d9"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f25697ebc239b30b60aee79f6c04450d7d19f47625022115a1d1e24c8ca03ab2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f25697ebc239b30b60aee79f6c04450d7d19f47625022115a1d1e24c8ca03ab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f25697ebc239b30b60aee79f6c04450d7d19f47625022115a1d1e24c8ca03ab2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad18fd19b8db51c7e9e47c8c535a191874bc3e77f7f77fb7ed2e57b0fd0fcc2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bf295b657493565d557089a1b2b4b13679143a8d9cc21cbee8097dc3d83117e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c0e7082622bf2c8698f612ba9ac5c016afd4cd81ebf2dc110ad460361efa320"
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