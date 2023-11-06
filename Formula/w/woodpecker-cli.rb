class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://ghproxy.com/https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "5e3246deae90b8dc709d9723b2463f73b4a55f5249f05e41e6153ac18b4c2c75"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4cdfa61755343f97e37cc43c7a7f304f1bd0c864dc8e088b83a84ee269e45f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1274caef2634599d7cff3fc690cbce1942369a5c86a5bcc18a04bd84bdaf3b09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9890e90710faad5e3e43c4da62bbac151f3367724ea7207c41160314cb64f16e"
    sha256 cellar: :any_skip_relocation, sonoma:         "39110c5695e1e9c4223e9187bb0b8a9b02479a146835dd8c2c3210dbe89f4a9a"
    sha256 cellar: :any_skip_relocation, ventura:        "f05cb169ab4ad92bc54a1f12b52afbaa76d136d0b2ce1109543e56457aa90352"
    sha256 cellar: :any_skip_relocation, monterey:       "d4a9b2c826273b86c7da5d03bbf6b1dd27a9a124dd494e77aaa3a6ee547b1999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff9827621a92c5a05d5c06bd9c86580811405f0d86e4fe55ea3a563e51866031"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/woodpecker-ci/woodpecker/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "Error: you must provide the Woodpecker server address", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end