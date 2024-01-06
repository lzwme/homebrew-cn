class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https:kyverno.io"
  url "https:github.comkyvernokyvernoarchiverefstagsv1.11.3.tar.gz"
  sha256 "7b70594b4a02b8f563601135194b7f63e2fb43b313ac4c7b211d6042511a7a9a"
  license "Apache-2.0"
  head "https:github.comkyvernokyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4912c17760048cac3c6aee8d17f32e2dde3b8c5e083969bccd28d1c02770d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1297f09ea72f984d105903e89323229ed42a157eb0b2bf771dc19442775b0cfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a256ee61c94b1bce6d65f64d743891c17755ccca781f695344171e924e68566"
    sha256 cellar: :any_skip_relocation, sonoma:         "7852189ec598eb2ff5ffc97a979219f4b9e89195e313f01bc31168eb07bec894"
    sha256 cellar: :any_skip_relocation, ventura:        "63c0c9a19bf2d2cacb419253e470ac1558b02fec58014aa5d35580bc641c191e"
    sha256 cellar: :any_skip_relocation, monterey:       "01cdce4157ce2032bf7424a657d4f7aad087abf3ea680288384b08613291ed55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd5758d9a9c43a233550c0427f7061d76e62af5d946a0f23f0b9e10194c5f5b7"
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