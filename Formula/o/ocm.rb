class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://ghfast.top/https://github.com/openshift-online/ocm-cli/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "f4a9e677f9eac9dd5a95f231691b05522206398e75d9d69231611bdb344c2fc7"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7a30ab0c6fed0ba68f2ebff3089b5279f47c565d3456d9773599fdde09a92fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb9d20d7ddd47dc32ec7f5ef1672a8c498b6c574c1903d299e83e5934cf70363"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ff287c59959c1c8f02912eacd16e720d596847486831d7f0c7ac65095124e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "221de31518d6b9874356cbc2afedc93a0b819fbcf40311e6d8a8129b1cce4c42"
    sha256 cellar: :any_skip_relocation, ventura:       "64fa5e2f33d57001e4e8eeb9a4852349c85c2888e1b8e019a4298c4e3316168e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e561bee9d70ab89dc3df91dda515d80be61f176fae87bd1af8ed6e64ce146a8d"
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