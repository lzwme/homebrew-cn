class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.28.0",
      revision: "4bbdaec56d621503ffac743e4fe29037f96841bd"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f70b3cc61045be1dcc1ba47336b5f5f95b28f005506677a274c95266c6f97a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d92a04d35beeda7e06c7b09157ab3d80234c455876b5bbf3f85f71b21bafda4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4fa8f229a98858cfa693d3dbfea17d0181a50dcd3810fe0b9668ee776baa1a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1cb46ff4e380fe2449f888fc9ae9879e90fe9af658c89069ecf40a4c2c124fb"
    sha256 cellar: :any_skip_relocation, ventura:        "15ed2cf623335659554387a7e2ee4f08b6891e3c767bc916189cf650c6b16184"
    sha256 cellar: :any_skip_relocation, monterey:       "e398d3395b10aa4bcddb6adc844b9045bc98ce2f666171dd2a533a971c330425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed586466e90411c475da94baef0a13dde24fa8a4e6a1d41859fb120b34865d7b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end