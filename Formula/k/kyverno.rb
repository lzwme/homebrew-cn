class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https:kyverno.io"
  url "https:github.comkyvernokyvernoarchiverefstagsv1.13.1.tar.gz"
  sha256 "ab1790aab12488d7e3c5b0fb2a28a4e795ede071562684f356eca37939ae015e"
  license "Apache-2.0"
  head "https:github.comkyvernokyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acde6c80758692280810cbedaa411448299e5b44c2e77164dc3390eb14e898e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8d5b6e0a93bdcceb33a6fea194ffa5ee98053ee1a057e9f8023cccd87dfdc02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83e90e602f55b85339b0ec42dccd3e527a2083ac89f0a840637541fa6c2784fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "20180198d3f6ec2e36f9ebb126840a5a6d9c81dc3fd205316de7e1e374e89002"
    sha256 cellar: :any_skip_relocation, ventura:       "4e214123ce4e7cb42ae7907791c84046350204c614b05a8727df6a5f13db581a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2040bcde2a8092e01de5f306e9fd09f856adcf46b923ff0910708174e8ce9fed"
  end

  depends_on "go" => :build

  def install
    project = "github.comkyvernokyverno"
    ldflags = %W[
      -s -w
      -X #{project}pkgversion.BuildVersion=#{version}
      -X #{project}pkgversion.BuildHash=
      -X #{project}pkgversion.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdclikubectl-kyverno"

    generate_completions_from_executable(bin"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}kyverno test .")

    assert_match version.to_s, shell_output("#{bin}kyverno version")
  end
end