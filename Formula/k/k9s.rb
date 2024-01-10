class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.31.2",
      revision: "65100b05d98d290a34359b1573723baa620c71bd"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c4051c346b85f860fe441af1cf753c672a19a1db427bd18b0ad4611a01aedec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0531a9b35810ccd634c0079237fab367d5b3d48dc63f5372ea756e3283966217"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f1de198daf5e55bcfbf3fa3097db79e910119244dd21b577db99b0bfd6b8364"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bb2b18650e5c40c69095e70ac7a4ffa4cae2aa8d31be6c9057ecba8f95379c8"
    sha256 cellar: :any_skip_relocation, ventura:        "1af1fa1a896d6df3304e2340921aaff171f4f43290c113a39e2b5038b5fb1495"
    sha256 cellar: :any_skip_relocation, monterey:       "0bf63c1e112c40075282bed3c88a4afb1684ca4c0209c56239b3c77d35fc03f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95d855836eed840cc2f79a49239347f2decd6572fe8ba07376fe21a9ff9eeb8a"
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