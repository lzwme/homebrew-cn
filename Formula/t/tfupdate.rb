class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://ghfast.top/https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "617a57d9d43642607e1bb5029f6f3bbbd8ce39cc5782d30c7fe32227401c83b8"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd83eb352ed04de769f5936f6535deeb4042cc2d5151b878c17dfa9953312cf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd83eb352ed04de769f5936f6535deeb4042cc2d5151b878c17dfa9953312cf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd83eb352ed04de769f5936f6535deeb4042cc2d5151b878c17dfa9953312cf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "47451115b6f6973756fd9b91a74979ba09807f30b5e306e9068f68d882d00445"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb674e38f011661c02063f0da7166debb012b7423b35e3d242e33b3ebabcdb1f"
    sha256 cellar: :any,                 x86_64_linux:  "60451c7175a9758256187d47f26b48bd9b8afa500412a98437b13f704f3fb64a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~HCL
      provider "aws" {
        version = "2.39.0"
      }
    HCL

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    assert_match version.to_s, shell_output("#{bin}/tfupdate --version")
  end
end