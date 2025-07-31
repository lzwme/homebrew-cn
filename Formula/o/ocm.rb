class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://ghfast.top/https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "4f9ad5c5a315053489b45e9a734999b2524140af45429853428b07b49b0aa5e2"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75c285702a82e9bd0a4325fb70c63c753efc4b743ce75f8b003828e17f77e996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85578ee854471f0c4004d79fc016f508d94ad77b2bb900b7d985fb9b84f2e3c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca62ac0bff4967c032ae8a26f626e2064b3667c0d2f2af088d09a097819f955b"
    sha256 cellar: :any_skip_relocation, sonoma:        "20203cfa2c9b5df45f40196a576b6247b073f5b27ee2f0249edc00174413a51f"
    sha256 cellar: :any_skip_relocation, ventura:       "81afd5ff188a87ddd67367a409b470917a453d5dfa2a45466e59bb5f84b26709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27064f13d906d180d816bb9e1c0a9cd84c4a3238590afb930e82517518d9aa36"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath/"ocm.json"
    system bin/"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end