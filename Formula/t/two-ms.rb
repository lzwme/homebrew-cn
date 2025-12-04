class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://ghfast.top/https://github.com/Checkmarx/2ms/archive/refs/tags/v4.8.1.tar.gz"
  sha256 "6186852dfd3ccee0f9b7c8156ce2b749f608d698f1a93f8c6339856946fb8caf"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca37a083667ab3aca6b19ae480d34802821e82c3f37f4805eebfd5e99d9466bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d53bcf39be824cec06c2457e596ce1ca420c4488ed5fa5b81f57ae5142824a58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36263fb8b45d7de67306575e755a5b28350c3e3fe9d3ce9084dbecc946d12014"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2cf8a77f8be53ad4342dc6723ca8aa02a06ae0011e73249f3bdc34e0606b5cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a28a09cf1066255789aa12083089e2ffa02ff0af7f68022710282c888326c932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d7a32ccd2793f7db2c5184b5836bf58edd7c14c47ee28affce9812fa9e0934a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/checkmarx/2ms/v#{version.major}/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"2ms"), "main.go"
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