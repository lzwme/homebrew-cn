class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.5.34.tar.gz"
  sha256 "441381d32306a6f85bf2c0620a507e0b66ba1f29341a8d9213111c26ac484c29"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "343d5afa79ed843c53782fd23c653b5b2a2b2b72da55551509fd52b65df8cc01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "343d5afa79ed843c53782fd23c653b5b2a2b2b72da55551509fd52b65df8cc01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "343d5afa79ed843c53782fd23c653b5b2a2b2b72da55551509fd52b65df8cc01"
    sha256 cellar: :any_skip_relocation, sonoma:        "59737d19cebedbfa5aabde7cfd06c53476aadbb7f937ed5b7fa75316f3dacc3c"
    sha256 cellar: :any_skip_relocation, ventura:       "59737d19cebedbfa5aabde7cfd06c53476aadbb7f937ed5b7fa75316f3dacc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12aaf4389577005512fbdaa5dfd5b677026ebf1f3218bafb567939aca772d131"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end