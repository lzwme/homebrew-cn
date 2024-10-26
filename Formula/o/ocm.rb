class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https:www.openshift.com"
  url "https:github.comopenshift-onlineocm-cliarchiverefstagsv1.0.2.tar.gz"
  sha256 "b384b4d8a24d98672739722ac112d0fe839239c0c14dc1dc9a9f0d127eea0327"
  license "Apache-2.0"
  head "https:github.comopenshift-onlineocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e457574b0de81faf20b259665898bf81adb725c1da5683308260b35ca3ed434c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dfbd0c835cddf6d97f16c1ab97709edcb948cffb997cc8b9495315bb5705caf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd3f0c21e12274504c3eda5fc03f394e311acafe7d85d3c606d65fea85a3f73d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3956432a29dcf5f2c7f2662c7b36dcd3d9d0c6a65801e7799ef6faf6b0d824f"
    sha256 cellar: :any_skip_relocation, ventura:       "3911d380da5535d2ee55b56078ca57406a486ff702ac4ef61c600470100a155c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e44d1b187cef89d7d099e593c9ed05a71f1fc55dfaaaa028607b15e7ee79138"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), ".cmdocm"
    generate_completions_from_executable(bin"ocm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath"ocm.json"
    system bin"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end