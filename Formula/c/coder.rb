class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https:coder.com"
  url "https:github.comcodercoderarchiverefstagsv2.8.2.tar.gz"
  sha256 "4900f2fd5bcac42192fb213cf19f67622b9d1180a319e5d2ac0d2ea1470c79eb"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "437ab4a9a4d34fae22070756b6243cceeb25cc59c2ff57a7469f646cb68265de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a5ceb527892516a44523f2cb487391a66dcfe4c0e44768bb98914d2f64e1482"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dc723d38d5f5b6f1970165eb7a5e221d04daac827a9eb5d5771df72e15626f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "38c944050a3def45220cdd977ab668c33afedb40dde787de2a4880b1fe2c2994"
    sha256 cellar: :any_skip_relocation, ventura:        "6e1762e1b6c34b516cd5d6bc923384393345ab444a354f14dabc43aba6417475"
    sha256 cellar: :any_skip_relocation, monterey:       "0392c161fae37b46481f2685776078e1c3420212f40a73430380ec3c29c79d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69338571ea5bc8a0891ffa3ffe6eee65453ea35263954dd2062f49b851ae25aa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comcodercoderv2buildinfo.tag=#{version}
      -X github.comcodercoderv2buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "slim", ".cmdcoder"
  end

  test do
    version_output = shell_output("#{bin}coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}coder netcheck 2>&1", 1)
  end
end