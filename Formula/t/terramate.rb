class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.10.9.tar.gz"
  sha256 "fad0853316bfa83353f83bfe28fb31dca46c2aa728f02b52505ec2bf5951fae7"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f5a6e78f1d62e9247efda3a7af24ecb4364d9927657fb336a46445883b60cd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f5a6e78f1d62e9247efda3a7af24ecb4364d9927657fb336a46445883b60cd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f5a6e78f1d62e9247efda3a7af24ecb4364d9927657fb336a46445883b60cd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d39ab58d1a94a34343194c141e2aa90ab3731abb06b30eb9a692423b57761d8"
    sha256 cellar: :any_skip_relocation, ventura:       "0d39ab58d1a94a34343194c141e2aa90ab3731abb06b30eb9a692423b57761d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0b0cf8d45d0df623a845f90c44294796ba7f16868549ad9aef5235559af2962"
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