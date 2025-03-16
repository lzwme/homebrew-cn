class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.40.9",
      revision: "fc5f1907c40b63e080ffe4ccc49a32dc411b8002"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef8e5c886db133d7a8b8fea7ad7e5d0bf9444d562df682598c25e7f77fae9898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52d8b2d3644bad5e86731d05a28843fce8ee6c56fa9718c8ca8a29e98629e71b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dccb97406c6172cad5ab73c941efd9c92b559c86adc608f0ebe7cd591cd722ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "671dfba37539397ff676b5fc19309f0b44ee7d0f07bf09f7ea535412f5e9a97a"
    sha256 cellar: :any_skip_relocation, ventura:       "75ed99a6a45dcb15fe20050cdec3037e72657a016bb2646bb1c325814a68f329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49d035c88c38ff931861b99ba25d2f3c756d58d5dc7d50e68776a25288e4e8cc"
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