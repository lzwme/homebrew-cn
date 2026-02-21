class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://ghfast.top/https://github.com/Checkmarx/2ms/archive/refs/tags/v5.2.2.tar.gz"
  sha256 "aa0932fb3b536a173022033beb2bf71ddd95f342f975c9922c905dbf63341302"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d916e335e436ffdb0fa23f43a66e347e9eb7c80b1aa7b3e7fe19b7e0bddd692"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6463eb9292318ed44f79c6792152bbdfa5c5d806cf8fb58ed9e29c91cae7957b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b02268c9285bad503c18b9a384efcdc904500aabbc43700026edf3dca66f2001"
    sha256 cellar: :any_skip_relocation, sonoma:        "236f6fbf8a74f8e07e71b7162d46072cf403fc477655e271274179b8f9cd9355"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3d43feec21479fcda2ed42f42753967bea99bf16a9e625c681e23504aa29eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9cf8ab37c806c8f0e787262e6c64ec849da8b947b968eea67f66bc9c2485b54"
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