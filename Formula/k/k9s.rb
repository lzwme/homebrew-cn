class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.40.3",
      revision: "5aeb09f72d315435520b51f028cf4dd814ec86b3"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77a3617aa9e0fd9239a2cf45bcba95b5418cfb0c70f94666fd7c0fa3fbd01159"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74ee14a9e84168dc35daccc076fc86c695c2f405471d0d7dbb5fe4b49c69cbcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92eddd0b5c59b824fe85a520d6a8d03d8818a6252e699e978ec32c5def57e927"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6be3b7d80a6a604a352e9aec078d6015778a413acfa1d813213d260faeabdc1"
    sha256 cellar: :any_skip_relocation, ventura:       "0efbf33477a5afb11d792c40c1eda9c42320c319fc0922a2573f942271012e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83fe3f4f58aa37f6c144048b59a7482b8a5954031fc4a5640b39249ad4ead831"
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