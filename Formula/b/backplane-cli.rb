class BackplaneCli < Formula
  desc "CLI for interacting with the OpenShift Backplane API"
  homepage "https://github.com/openshift/backplane-cli"
  url "https://ghfast.top/https://github.com/openshift/backplane-cli/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "ebcf652ef7f67877c262e15ecf74c60cd46a1bd1c71745204e4b0a12b317dba8"
  license "Apache-2.0"
  head "https://github.com/openshift/backplane-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36ae85c5ea76c2f78af557a2b83014bf17b65560b797a02c2882bc86abd78d32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c5402de3ecadb2f623c76da31081c1befd868cb0eea68d41f5957eacf58e6e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b62845ce418ab45687081fbc8beb50b2aa6a9825335b5fb46d5d044afb762e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a17b85336d89147cd2e75be65e7e7b034b5ce33d14b85bf6bc98bd5d2fe0479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "147a959230e7422707a565e5a4057ab10c630b9615db221b290e0afb602c52f1"
    sha256 cellar: :any,                 x86_64_linux:  "ce2e91118cbc45f984397735cf577d2c549e123a567e2e89d7d84522b16bbf98"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openshift/backplane-cli/pkg/info.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"ocm-backplane"), "./cmd/ocm-backplane"
    generate_completions_from_executable(bin/"ocm-backplane", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm-backplane version")

    # Verify config set persists to disk
    ENV["BACKPLANE_CONFIG"] = testpath/"config.json"
    system bin/"ocm-backplane", "config", "set", "url", "https://test.example.com"
    config_json = JSON.parse(File.read(testpath/"config.json"))
    assert_equal "https://test.example.com", config_json["url"]
  end
end