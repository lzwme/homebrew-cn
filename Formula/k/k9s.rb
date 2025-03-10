class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.40.6",
      revision: "a8b75ef1e52731c3e20a9e53c74fd83d5e4ed9ce"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bac2cb2bd01768ecd2a8ef2e59b3f0a0c2331366da4a37fd09eaaebcc653195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29004465995e68bc9dc54db07ec94cc32888a917d1d8ab2cbb838461ee4ca6a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ec35ec4d587ea3b31e2a4398daa74f1c7c0b0c2af2f5aa42673a72a1814ba1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca4290114e9f78f378db64309bbdf097f362fb1201e2e20b4b6ffb38693635e7"
    sha256 cellar: :any_skip_relocation, ventura:       "64c5b8e0a5a97be303bcbdd6eae5cd26c4cb385e7701cd09d0236250bf688078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dd7f8f547bc327bdb7521dd9e95469da783d7aab5822b06f81f0d1116c80fae"
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