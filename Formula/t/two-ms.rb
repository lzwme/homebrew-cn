class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://ghfast.top/https://github.com/Checkmarx/2ms/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "f70c9448e42b2410a0dc294cd90e0849b67b579bb9ba481717957daa8811f30c"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdb6b3280f7c11ec9b09e11028344b079726573d9d272eeb4a35a06388b1651f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35b82b12653a5d67210a95fb215560f064da933941b8a4efa6f773cdea33c78d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ced39b3dac281dcf6e0f128c034b3ef3d7feb635a5f77403734c0b3912128862"
    sha256 cellar: :any_skip_relocation, sonoma:        "3966a1ec28e3a51ab65f3445772cd5c504b1a2236e8bc76fc42beef456bf471e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d0ddf34605300b45fe0713d4b3fa8cdfec92cc10b008898a40ed5c36eeeebdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db8fd33c8f86e5c43badc57e50a16d30c8626a10bdb6b7c13c8d8bfbe38f1c4b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"2ms"), "main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/2ms --version")

    (testpath/"secret_test.txt").write <<~EOS
      "client_secret" : "6da89121079f83b2eb6acccf8219ea982c3d79bccc3e9c6a85856480661f8fde",
    EOS

    output = shell_output("#{bin}/2ms filesystem --path #{testpath}/secret_test.txt --validate", 2)
    assert_match "Detected a Generic API Key", output
  end
end