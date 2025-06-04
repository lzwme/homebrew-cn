class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https:kyverno.io"
  url "https:github.comkyvernokyvernoarchiverefstagsv1.14.2.tar.gz"
  sha256 "23107c7ff59919e60d8d2b2fad2e7f486c2862237c998d726916a90a548709ec"
  license "Apache-2.0"
  head "https:github.comkyvernokyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd401806800e44d21518c1d4099ef2d87bdece7d21edfa31a693a20db936dad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "783fd379425ab8ef3f144a3af476446ac2a8596bbf6b1c88d986dfc93bc7c6a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39bace51b95528db327f8f5b6bd775c14f8e595c44ec69138123f52fe8d62d92"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc5282b112e682673e9c1d415a272af9194e73a92cfa42fa9601a17a832cbd51"
    sha256 cellar: :any_skip_relocation, ventura:       "5b7c3c0aaa095d5a71bf7cf902e1af30835607bf12d8b0576c006a9bf50e4ff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f0636a33590f0626824508caecdd5bcf76f7ccb76f2f59148b622c5b2636b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3cd00a3c791c025bdbc1fa4b9a36c39addf6df0a2d59195cbbe224f1ff097d6"
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