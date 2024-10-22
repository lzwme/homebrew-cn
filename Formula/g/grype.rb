class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.82.2.tar.gz"
  sha256 "efbd5e5c5c0b97f71ffaf5a638c9aaec14739478a38a79d0ed469a7e6c5689fc"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86692bf61a66fb5b0c39e92fc427549e6595b986d57a5be218a5b5d9c548ab3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb128154ab224a78917b011e6a7a3c74872fc129566d491a7b8c8b917f817912"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f9ec26ac85ae43436b2a8ce46a50d952c07cbb4b629e8db6693c7c3c8b2f3b29"
    sha256 cellar: :any_skip_relocation, sonoma:        "d90a9815093319d70a0eb0cf006d27ea03042675d88b3030415b50220993a88c"
    sha256 cellar: :any_skip_relocation, ventura:       "b2eacf6cfeb935e7f025b3e724523b80e318497cb89e7eb02b9074ee57482546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b4df43324d0ad2a1d4a388b351e2af7066d0252bb724e0a1ed03682e325c5c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end