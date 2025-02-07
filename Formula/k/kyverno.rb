class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https:kyverno.io"
  url "https:github.comkyvernokyvernoarchiverefstagsv1.13.3.tar.gz"
  sha256 "50f376c774beaa8cf64ad5035c85a26f27c96d03190db2155046843ed7fdea88"
  license "Apache-2.0"
  head "https:github.comkyvernokyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9aeb437cb16c0800296d861a9a8cea93bcd75500df44b3e830cd4826df21107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2f40e4eb8bde4db7642c576a806ca993db5836a27a3a490a9774626d158a6e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a328cdf1a7c77e75262dd8879dc73df6dc94194d9539d689db79030e76f804d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "05c58e0a018e75489c3f01a6570870b3b185cc6197fa0b3d92dbfd0c61df92cc"
    sha256 cellar: :any_skip_relocation, ventura:       "ef6f85a14119d686b6c2bbe03fde6bc1bbb0975236afa23ac1379c1a4eaae426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29b7bda5cca48f0cda11baea5584a4635cfda875b3b00f6aba6a9d40197c0f9f"
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