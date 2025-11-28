class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://ghfast.top/https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "11c735be6e50ffd660cdda11151d1a287b7b4d1a474662b153af8d4c20bd8941"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3aaeb9a350a50df3c2da43c439acb3737a6b95c4769b307cb7c492089bbaad11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abafd8649468a478e7abda76865373d6b1074df5357d34ee2fd18e75dba8f26f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8faeeb7132540ef64c281b216e98eada22e3580b29a6eca4739574acff8e174"
    sha256 cellar: :any_skip_relocation, sonoma:        "da2ab2fd3e1231cbbcbdeb2803f781108cadb0b9469288a94ba06669410735bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "745ce4b675ec37fdaa5f5f268b0a57177d953a06d084c116045b24c00d5b030b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b40c526d9c71c2c8c47a47a8998926687b7a57dbccbf0795372a980519bbd4"
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