class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/cloud-nuke/archive/v0.29.2.tar.gz"
  sha256 "2aa6719d0ea6a50f12e459a2f37dfa7408d64a6b6a1dbe5334ca7017948b418f"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ce117c248bb28e5bb82dc2b541f1bfd436e96f43c565a27061681eba49e7eac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "964f35eaecf6eb76287366ff41e6cb9392314f62bc7727d439bd0d669921b5dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a17fb771e3bd4fdb26df91904b96d54a4f069f2cdea2f667a5e6b7c523b49415"
    sha256 cellar: :any_skip_relocation, ventura:        "e45da0dc4d89fe655edd0f01279157459793cb48cf08c6488295c9e6d37e042d"
    sha256 cellar: :any_skip_relocation, monterey:       "548e9e046b4abced78359253f3856c983c33cca0523634fe47863b6b157b4c2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8cc8973891b298c38d3db76dac9286dc2847fb52ebabb8b035a546984165779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23221b0404c337dc85d08ea5f26f5ff57c8b72f4b6d296ca033bee8519b292dc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end