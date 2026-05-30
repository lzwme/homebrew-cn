class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://github.com/cozystack/cozystack"
  url "https://ghfast.top/https://github.com/cozystack/cozystack/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "c6f7c955f977f398f494f3c682f5cf967f32e6d4e73f387be69625aada6c71f2"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5badc63774459a2a0bd7add2398fd150f67807e8636206a43f932c80001e95bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5b156912150d7dfe96b1bf7fea29b1259db30c2ebd9e495ba1bb00fe34d564c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2027dc32839d718f49f3d7943412351c540f8cccd9a016b44ecd54fc439508b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "503df95236611600b253c12d9a222b0a19ff4bf1a01bc1bb5441a0b20309c8a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00aa6d3ccf46fa1b489b363e06cb5325c08edd30a75faa7227c6cc47107f4f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1375bc110b1fb87fbfbeca3989b871c765bce1ba8664ff6419229d1767f6ae58"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cozypkg"
    generate_completions_from_executable(bin/"cozypkg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    ENV["KUBECONFIG"] = testpath/"nonexistent-kubeconfig"
    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "failed to get kubeconfig", output
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end