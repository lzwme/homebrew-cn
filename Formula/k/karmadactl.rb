class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https:karmada.io"
  url "https:github.comkarmada-iokarmadaarchiverefstagsv1.11.0.tar.gz"
  sha256 "07aa4e1036573a960c754cd56dda2699b77c4e5f6a90618a21d7d74897cdd4f7"
  license "Apache-2.0"
  head "https:github.comkarmada-iokarmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f5cbb50c1d49382f828ba30bb1aab67afcaea127008e026b09bb38471010f08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b38b78a2c1ed9507a69581bdcc87cd79a643b020223da69771b93fcedee8cba7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e59aa3fab0732b995b7d4ac6be3371b1c0326d9396ad3a54383c3ed2ac19d808"
    sha256 cellar: :any_skip_relocation, sonoma:         "32e0ff1a731a92217810c438c92d037f4372ab81a36827984a58aa133ff2ebb4"
    sha256 cellar: :any_skip_relocation, ventura:        "3bdffe09825d315a95b68d5e8655d66c625c56c7ecdbb770c3823b26182d47d0"
    sha256 cellar: :any_skip_relocation, monterey:       "639de4147e8bf79a4b53ffeb439cb679e9bca934e294a6c596499e64539d8b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7332d60e0ed72539a5a5c0748c035f02f3a0a2477543ecb5e7434f28bfdbfca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkarmada-iokarmadapkgversion.gitVersion=#{version}
      -X github.comkarmada-iokarmadapkgversion.gitCommit=
      -X github.comkarmada-iokarmadapkgversion.gitTreeState=clean
      -X github.comkarmada-iokarmadapkgversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdkarmadactl"

    generate_completions_from_executable(bin"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}karmadactl version")
  end
end