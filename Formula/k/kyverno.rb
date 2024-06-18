class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https:kyverno.io"
  url "https:github.comkyvernokyvernoarchiverefstagsv1.12.4.tar.gz"
  sha256 "8ec0b38094c9b988f441c4859ccda0e4f612deab4651ba577816ffca79882963"
  license "Apache-2.0"
  head "https:github.comkyvernokyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fb1ad6b788f7e69100029949646e60aeab4c4b025106c54fdd3b343484f8dc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b82d0509705c861061a1fa862d15bfe4b4c7794b992227bb72564c75ec9d4d87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f839d5ba99c284c9b3c99def3932d751eecdfdc029ca8250bb32772d9e191c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bb443c1d3562a2f16dedd0bd0cc100679891c347798385f1d9c8c39ad08bfbc"
    sha256 cellar: :any_skip_relocation, ventura:        "45692bd91d6c3e5134025f49f7e4cf76cf42a66d439b171ded00947c3be8ddf7"
    sha256 cellar: :any_skip_relocation, monterey:       "c42c58de292c505e2cf1620a977a66b37602a9f1b54f1dbdab321513a678cebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72ad27f808a19b166bf00a71f3d4ed6e9c4d59089a72c71ad991ec908eef1535"
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