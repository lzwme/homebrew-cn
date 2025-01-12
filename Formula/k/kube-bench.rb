class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https:github.comaquasecuritykube-bench"
  url "https:github.comaquasecuritykube-bencharchiverefstagsv0.9.4.tar.gz"
  sha256 "d1f7f4837485cb34cb6e1b8141d20ee8eb0e3db30c52dec6a329f73721251422"
  license "Apache-2.0"
  head "https:github.comaquasecuritykube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da842a717f44a34d430bce35c7ca9d44ba6cdfff9b5656372741617abd535557"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da842a717f44a34d430bce35c7ca9d44ba6cdfff9b5656372741617abd535557"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da842a717f44a34d430bce35c7ca9d44ba6cdfff9b5656372741617abd535557"
    sha256 cellar: :any_skip_relocation, sonoma:        "93fe13161db7fc7e9a5bd5ac80122238bf6e1fdded8918e4785138f0bd88de7b"
    sha256 cellar: :any_skip_relocation, ventura:       "93fe13161db7fc7e9a5bd5ac80122238bf6e1fdded8918e4785138f0bd88de7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac91acc5024d45376c9b9f97a8a69d6853b69559bb8ff55952f72e5a99185dfc"
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