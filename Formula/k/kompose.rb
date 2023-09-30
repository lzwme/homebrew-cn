class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://ghproxy.com/https://github.com/kubernetes/kompose/archive/v1.31.0.tar.gz"
  sha256 "fd2a8c302e24d53609bc9d783eb557ff26af35e21e9227932238c22ad1373fa3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15fa0daa71675c387dcd76552d9091b9a3630cf27591159bc6b1e4c643758d0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "150e78dd9f193ab31258c3935dd1e0591fc5ddcb0670f8b6292a9fbb4fc8af56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d594e719590745123b6ba12be52e231df766766ba118b25f0e7749faf3cd2e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cee899e22facdd74d21788a7a22c1905b7dc3d3765e9f28b21d194275b6b044"
    sha256 cellar: :any_skip_relocation, ventura:        "d6f60897876dfe5bc05cb3455ab8b9ee41ae77453cc3f13ee52e008089847ac0"
    sha256 cellar: :any_skip_relocation, monterey:       "7a875aa918014cdd79a685e455c047b39070bdbcdf1656175c89923eff613a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b79fdd892a54f46c8d8812286b7063cddbc4b48b216eedce6de4b88028ccc9c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end