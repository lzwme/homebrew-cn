class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.90.0.tar.gz"
  sha256 "f4628a9b13e98080487284665308dd198672c8e127c2629874ed970ec1ca151a"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f04100f31b3ccadaab3ee412f3e6f43d11a70435bac72c04924aa0352bcfbd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36bb628a9566c81869dfbae56860039effce7c5be9252d0150dd65db7ca5ba85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8fc8d26fd1a8eb54e3523095befec4e110766fb8b0579087f2b472bfe3d8cb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a7f8ed4d06e52df47a4f6bddc082f30510fda1daa0aff93ff601a9b0fd63fec"
    sha256 cellar: :any_skip_relocation, ventura:       "82467a2615e21cb68acf6981094012aa543ec06a9976ce7d5f5cfa4870cdc09a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6d2293c15d5bf23600b8ae2abc8b4ef546f2f99edb1d407d7c1e56d0c018bab"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end