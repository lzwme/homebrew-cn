class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.2.3",
      revision: "2842ec90a2d8143dd90211b083ace7325e6a3a8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d93951b54cc817ca43abfc01aa0dde589149b42c163e9c53fbe8d7d7bcfcce9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d93951b54cc817ca43abfc01aa0dde589149b42c163e9c53fbe8d7d7bcfcce9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d93951b54cc817ca43abfc01aa0dde589149b42c163e9c53fbe8d7d7bcfcce9"
    sha256 cellar: :any_skip_relocation, sonoma:         "dabed1e3d237df70820581caa2e14403fb0c1b23fac82a2100171a90a1fee504"
    sha256 cellar: :any_skip_relocation, ventura:        "dabed1e3d237df70820581caa2e14403fb0c1b23fac82a2100171a90a1fee504"
    sha256 cellar: :any_skip_relocation, monterey:       "dabed1e3d237df70820581caa2e14403fb0c1b23fac82a2100171a90a1fee504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29cb415061ecff5ab7cb35a380ca6b04ce92e03348c4558b3333323da64091cc"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.commit=#{Utils.git_head}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "docs/xq.man" => "xq.1"
  end

  test do
    version_output = shell_output(bin/"xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin/"xq", "<root></root>")
    assert_match("<root/>", run_output)
  end
end