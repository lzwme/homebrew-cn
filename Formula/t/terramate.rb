class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocs"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.13.2.tar.gz"
  sha256 "2604def6adadff105137781d5f3d6d020fc9bc9ade44a51669fbad145a08b0a8"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dacc88bd71513a0f8ce638afdfd76809bef47d8f1054e60e05d3285ad25caa9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dacc88bd71513a0f8ce638afdfd76809bef47d8f1054e60e05d3285ad25caa9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dacc88bd71513a0f8ce638afdfd76809bef47d8f1054e60e05d3285ad25caa9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "81322d1101c815c322887dec2efc1f7da5cf088aeb823d9d651e3aabe8eb8cc2"
    sha256 cellar: :any_skip_relocation, ventura:       "81322d1101c815c322887dec2efc1f7da5cf088aeb823d9d651e3aabe8eb8cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf56b95d7a813175189c93afc70288a3541b9b2d968e49e4ef26a5684ecb949c"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end