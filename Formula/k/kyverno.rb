class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https:kyverno.io"
  url "https:github.comkyvernokyvernoarchiverefstagsv1.11.1.tar.gz"
  sha256 "ad6c12164851c9837024d4fc13749b251fb75c9be02cf42e70400aa4311b2644"
  license "Apache-2.0"
  head "https:github.comkyvernokyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ac1e06300692f5aff659ea774c763e953403acacde5934b724b2738ea118757"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eaaa3ac17047c302af98e3a61766c5c39f9d3e452365c9629126f401788e527"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "149cd73d002a52c974108d2ee97c9bb3420dcce6bb70488bef2a47aff28948bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "41deacdaed5c172bef75c59ae14df6aebdba4883cff40bac93f57e36445c5292"
    sha256 cellar: :any_skip_relocation, ventura:        "d05b40a032d25bcdca46c078fbb1742a50504ac338548c8b60577567ae9eee9f"
    sha256 cellar: :any_skip_relocation, monterey:       "a2e9054e065f4d03e2fe575ed1b621f08e7219cf80c62b7ce0c7205d93d6389b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e4985cae283825e5f7976012e36dedfa518e0750c500ccc38ae93c53d9f3438"
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
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdclikubectl-kyverno"

    generate_completions_from_executable(bin"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}kyverno test .")

    assert_match version.to_s, shell_output("#{bin}kyverno version")
  end
end