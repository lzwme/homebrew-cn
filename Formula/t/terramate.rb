class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.11.3.tar.gz"
  sha256 "e37f2f932f60f13e8ba4c35ead52389179bd0bb4e0923db05395760ce6b3d3b8"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b8e7f01ab3bc5e22be29dcdfba83119dee3fce53f463ac0d74706ed4a0e805"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09b8e7f01ab3bc5e22be29dcdfba83119dee3fce53f463ac0d74706ed4a0e805"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09b8e7f01ab3bc5e22be29dcdfba83119dee3fce53f463ac0d74706ed4a0e805"
    sha256 cellar: :any_skip_relocation, sonoma:        "2708b93577f46081dd815b808b624a830d34d552b4799a5a8ca718e831e5c125"
    sha256 cellar: :any_skip_relocation, ventura:       "2708b93577f46081dd815b808b624a830d34d552b4799a5a8ca718e831e5c125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "191e2a869729c5b0cb7cc712233d8b84db4cbd63d0efa26639e266ad880c3ace"
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