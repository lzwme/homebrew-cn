class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://ghfast.top/https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e112a5d5af45f6ec316a7a90bc4a9ec73220de5927bec3147c8bbf7fdcde8419"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40c67497fc838e1e558d040001a20b11bb4c1e0933cfbbe119dfb7591a132c28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40c67497fc838e1e558d040001a20b11bb4c1e0933cfbbe119dfb7591a132c28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40c67497fc838e1e558d040001a20b11bb4c1e0933cfbbe119dfb7591a132c28"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3910b3d0c5d2b31d16409ecd0da23798b37ebd099a03da56f7ec742c053fdae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd97e127e89a351510a1f0e94b56f635588d2d9c4dbd2f6553b07e8eee5166de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acf9d9839367fa67bf0de032cf64cafdb02fcb36f543e2c63b255252b2431a82"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end