class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https:github.comminamijoyotfupdate"
  url "https:github.comminamijoyotfupdatearchiverefstagsv0.9.0.tar.gz"
  sha256 "d53edee3a1146bf4f76dc3a184817da6099bae58572c0344bc90bba59638c119"
  license "MIT"
  head "https:github.comminamijoyotfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "758383e3b5dc2d5986f94bfd918454622c952950d1bf80bdba7d389dbf854859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "758383e3b5dc2d5986f94bfd918454622c952950d1bf80bdba7d389dbf854859"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "758383e3b5dc2d5986f94bfd918454622c952950d1bf80bdba7d389dbf854859"
    sha256 cellar: :any_skip_relocation, sonoma:        "a97263cf53d5059a724cb3825ef2ef9a7b497aab9d90828786500911aa786f6f"
    sha256 cellar: :any_skip_relocation, ventura:       "a97263cf53d5059a724cb3825ef2ef9a7b497aab9d90828786500911aa786f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a59de4820aed2f0c7b73a3674446d027c1f1e28ca6fea036ca7670f5023713"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"provider.tf").write <<~HCL
      provider "aws" {
        version = "2.39.0"
      }
    HCL

    system bin"tfupdate", "provider", "aws", "-v", "2.40.0", testpath"provider.tf"
    assert_match "2.40.0", File.read(testpath"provider.tf")

    assert_match version.to_s, shell_output(bin"tfupdate --version")
  end
end