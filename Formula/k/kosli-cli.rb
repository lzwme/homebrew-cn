class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.9.1.tar.gz"
  sha256 "0a51f4457fca60c823d55672c68fc639f0db0fbf3b05088069bb6eb22130a32f"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37cb045cdea085850402e519ebb55772fc9ed4a6d47ae675421191a75ab7096e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da44db4c85c39b0e5e6b8e71398ed65865429b9664b10a8c93e83d06b6dc5059"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df8e8d83379c92fdc8c91a4273757377c784d7ca1ad100ac866ea9ad107d14d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1efc362d1ce1edd6fe5b4e0f24b242a470c61a68abb51bf94b9e7387a43e5f88"
    sha256 cellar: :any_skip_relocation, ventura:        "810e487d946fb22b3701cb66cefcb0c361afee5b94ee76bc363b67994cec0937"
    sha256 cellar: :any_skip_relocation, monterey:       "6c80db54e9b2961f39f1a470356cfc22925ae2384a6026b7b2d298fdd29f9959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dcb5f141f447328711f28bca5699b47eb2b3713183b7b13762d1a36665db322"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end