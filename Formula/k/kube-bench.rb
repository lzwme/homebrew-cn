class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https:github.comaquasecuritykube-bench"
  url "https:github.comaquasecuritykube-bencharchiverefstagsv0.10.5.tar.gz"
  sha256 "cea3056cb5882e90b83204b2382e297e6b0f74a9cd4de2298349e87259dc7750"
  license "Apache-2.0"
  head "https:github.comaquasecuritykube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1193934b9c4c85c8758d67b0b912c587a1e8a8b76cf18b107fb95682fddf06c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1193934b9c4c85c8758d67b0b912c587a1e8a8b76cf18b107fb95682fddf06c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1193934b9c4c85c8758d67b0b912c587a1e8a8b76cf18b107fb95682fddf06c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bf601d1fccdf2c1812ea44ccd5a7fc23acfb57ca23f6abf53e51c67f7a9a345"
    sha256 cellar: :any_skip_relocation, ventura:       "2bf601d1fccdf2c1812ea44ccd5a7fc23acfb57ca23f6abf53e51c67f7a9a345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0630e64a3751231682ead28f5f6c6ee9be38319c0e84c1b3babc457b702247dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comaquasecuritykube-benchcmd.KubeBenchVersion=#{version}")

    generate_completions_from_executable(bin"kube-bench", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kube-bench version")

    output = shell_output("#{bin}kube-bench run 2>&1", 1)
    assert_match "error: config file is missing 'version_mapping' section", output
  end
end