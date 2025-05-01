class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https:suzuki-shunsuke.github.iotfcmt"
  url "https:github.comsuzuki-shunsuketfcmtarchiverefstagsv4.14.6.tar.gz"
  sha256 "5441a295b56fc91ca94b6452e9836a2dd2dda3fbdf8984baca404afe4964cac4"
  license "MIT"
  head "https:github.comsuzuki-shunsuketfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86bd6c7d306a98da5a95b7f99b5fbaed3d5126ebc3a580b534e9b3550564b135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86bd6c7d306a98da5a95b7f99b5fbaed3d5126ebc3a580b534e9b3550564b135"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86bd6c7d306a98da5a95b7f99b5fbaed3d5126ebc3a580b534e9b3550564b135"
    sha256 cellar: :any_skip_relocation, sonoma:        "9979bc858bd99697684285a13d85f2ca97c2896f6d2e38a50734946ede24da8e"
    sha256 cellar: :any_skip_relocation, ventura:       "9979bc858bd99697684285a13d85f2ca97c2896f6d2e38a50734946ede24da8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d73abad2bba2b42121984ee21bdc8a8277847ea947377c57780e87007ff109a4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdtfcmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tfcmt version")

    (testpath"main.tf").write <<~HCL
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

    output = shell_output("#{bin}tfcmt plan 2>&1", 1)
    assert_match "config for tfcmt is not found at all", output
  end
end