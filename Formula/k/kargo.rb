class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "f1fe84aaaf968852bfd7a1802a23beab32aac4a42358a5596be5d91b245a7fb1"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38e6643b68f4ad1868b3ea7ede0d0936a4fdb4c8e19ad57d2c3c4db61974c919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea83f8bfd22084d989047f1b66bb99aed39f267b3ccbc3b5508e29640ffc4be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "234178548b45cb14a13613b7e6203aa16f8c609b29f16dc202c343c8f595598a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f6a75ce7fb872d17a7a4fb06facf2942a4de1727ae4eb0ad5789239d797cce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bd6ef1d29949244f91c1e6eebdbf910d2788f84e57e6f1e7c3ad89f8cd25dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a2fe1e61339909bbaa3cdad01700fc8148b4056b9aba8712e488d1719c77697"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end