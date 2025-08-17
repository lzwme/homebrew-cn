class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.10.tar.gz"
  sha256 "3468fbfe49809acbce8ed4475cd90975c991c8dfa1dcddb82fc6f4ef4baa5c2b"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90c870c45611a1196724b03833d9abeb8719e7a012de32bbe4fd74a5295f4654"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90c870c45611a1196724b03833d9abeb8719e7a012de32bbe4fd74a5295f4654"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90c870c45611a1196724b03833d9abeb8719e7a012de32bbe4fd74a5295f4654"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2247d8fd676ae35d8cf4e6ac33474262bfbab5a67842b3db2afce643e6c7337"
    sha256 cellar: :any_skip_relocation, ventura:       "a2247d8fd676ae35d8cf4e6ac33474262bfbab5a67842b3db2afce643e6c7337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bd31f5b512082e9d41ed41d98c3b3dedb1effba34fe22d24be8e059eedc4025"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfcmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfcmt version")

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    ENV["TFCMT_GITHUB_TOKEN"] = "test_token"
    ENV["TFCMT_REPO_OWNER"] = "test_owner"
    ENV["TFCMT_REPO_NAME"] = "test_repo"
    ENV["TFCMT_SHA"] = "test_sha"
    ENV["TFCMT_PR_NUMBER"] = "1"
    ENV["TFCMT_CONFIG"] = "test_config"

    output = shell_output("#{bin}/tfcmt plan 2>&1", 1)
    assert_match "config for tfcmt is not found at all", output
  end
end