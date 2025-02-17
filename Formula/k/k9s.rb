class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.40.1",
      revision: "61f0f80c4a5f31ba5b7ad3cd98ef622d5aba8edd"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a26eb472637caaf727e3afe0de2ae3efc3199d129aeafb88de033883818c71af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc9093e163a61ff99b6752f2077e3cd176237bb98f2d49e8753427459bd03784"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5917f493473359ae4a7e90dc2909f99d80368062b387977e122828ba2401a1dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "11426b4ad3ea2ccac5088611a1940143dcce6ad61de82a0fd02c6c2daf58b48d"
    sha256 cellar: :any_skip_relocation, ventura:       "8bbe3da12dce831f4da1af863e88b119f58291bbfeac64d674d1ecf5b925af09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "521703a767017be1d50fc6b2b1d58eaf87bf3281ddb478769c2eca2f851b2e24"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedk9scmd.version=#{version}
      -X github.comderailedk9scmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}k9s --help")
  end
end