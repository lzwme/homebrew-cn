class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https:github.comaquasecuritykube-bench"
  url "https:github.comaquasecuritykube-bencharchiverefstagsv0.10.7.tar.gz"
  sha256 "3093fce3c988f5513927919dbccc7db9f5cbbff167a4f803be7872f9b2714fdf"
  license "Apache-2.0"
  head "https:github.comaquasecuritykube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8d97035adb7c7a808754f4566b1031708ad1c787bdddefe3cf4c2292bc953b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8d97035adb7c7a808754f4566b1031708ad1c787bdddefe3cf4c2292bc953b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8d97035adb7c7a808754f4566b1031708ad1c787bdddefe3cf4c2292bc953b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b1a41a96fe5e838c21856c6c3de3f8dac3776897a1a417ddf85f35b155b8c96"
    sha256 cellar: :any_skip_relocation, ventura:       "5b1a41a96fe5e838c21856c6c3de3f8dac3776897a1a417ddf85f35b155b8c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "948404e97c57a5493979cc897b92a2e85494b66719a337d76ae2e12c7a1ab0f6"
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