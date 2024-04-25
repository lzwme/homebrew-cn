class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.6.5.tar.gz"
  sha256 "eabb1ebcf4beb8ecfb68d24bf3ed8d3a821ac351c3a1bdcfb7905631a976eecf"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d715c3541a370dd377866dee2a3eda1ea9932faea95d620a1795750bbd9cd527"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7cdbce1bf6a4dff037be1c3243ca150bee6f6e19fb554c7a1dbee52e0dcf6d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7128cba8e298a427d6519ac5c637615ba77c6bcb0bb0b260544655c3ec5b15aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b5dc400fe1364f569500ea6fde3f053cdeea383a6e3507d6c56f02cc6866be2"
    sha256 cellar: :any_skip_relocation, ventura:        "7c5266a7fc7511ae680155c472b0f9b17875656de8736ab3e32bd3e079791483"
    sha256 cellar: :any_skip_relocation, monterey:       "9511811f8ba14a682ce1f598a98de070411b532e92b1905eaaf166215df18442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f20d3da748ead5af0e1bbd9491e62e2ffac065c196ae71a1e6fa080255f25912"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end