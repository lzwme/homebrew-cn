class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.269.0.tar.gz"
  sha256 "9c5362f345e9c0c821cc54135a3037dc3cd97cfa19a3e83099493dbe34c5df60"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca5ef27298387a6b20a2b0a0f039e0051aec7a112bdb4f20cfbbf27c7177528b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8969cd9412db6458dff5eea80fa04eab1937a3d279a69935dd1e8fb8fcf4a122"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf22ae9d108ee0ca72469b942db83391550e1e60b1043e2f00e7ee90209380f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "397d8d900b8603d41f40584990386a935aca34de8f51785b9ace3915464c99b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bf1f0ce079b69851b67cb2fafdf7b957634a119331178f69008e2b8637b8ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5fab59ad7b5311ee257963597c36b5ef120e700a513d536a965175ea145208"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end