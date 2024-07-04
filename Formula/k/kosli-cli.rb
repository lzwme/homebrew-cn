class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.10.tar.gz"
  sha256 "5b1bbb37b16ac5bad9d3a1ce14b2bb787ba3844214c9e856d8cc33e2562ab21d"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "075d64fd0a3603cd4e7dacc8f293e2c6fc47deaac2c45a5dbee0cdd98d313892"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab2707238012bc45f223e914de10072b46edcf3ee01371d2565636991801e1a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e52a346f770f3873a849da8528396fcf070712d35c5d2b221a5d20d63f1c9f88"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8f9ff11391ffcd585ca882d68cd7b63f1ca9a769efa6795e5fcc75581592cf1"
    sha256 cellar: :any_skip_relocation, ventura:        "860a26ee5c653f608ef9f9e8479529019e2d2ef96b454a19d34efd3e6dcf049f"
    sha256 cellar: :any_skip_relocation, monterey:       "3d830e408424a9f5db76caf18ae0a339c83ade9c2b983695e80b0092a615502d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "112446577e908af785448d634b048b8528f69b15bff8bdc33dd970c91ef78d8d"
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