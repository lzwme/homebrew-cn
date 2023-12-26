class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.30.3",
      revision: "26d1585699fb1faed828161c13265200f83486d8"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e22556f76730f7818904c0b1f0cda8cc70debf57b424dcbaf364e1635d6c0506"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "340d77118cb59cd7bd4a2d473e113fb0fb14287bae0814dafb01f77669af480c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "835b71a1557d3f5c844ce090be65ced72cead38f0fdb50f0fe2e616f923f8d61"
    sha256 cellar: :any_skip_relocation, sonoma:         "84323cdcb5a4db74aee529078a3bb568fd1ab0bc735b63cb5d0f5b3395835029"
    sha256 cellar: :any_skip_relocation, ventura:        "0cb0e53b767293e03ef5cc9eafcbb75abe8fa3459385a38879261376a8e3026e"
    sha256 cellar: :any_skip_relocation, monterey:       "11cca72d2dc1fc79ad66792a503f5311b235691f19962b2b5b0af1438d837498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "091b6ab5a6667db77f9dab0481576d925389644823df8c19c275027d037b3d12"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedk9scmd.version=#{version}
      -X github.comderailedk9scmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}k9s --help")
  end
end