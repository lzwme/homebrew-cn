class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://ghfast.top/https://github.com/Checkmarx/2ms/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "0e5deedc20c51f21d5b044dc0d30e086ce2957d9c8050c6fd4db5da9ba852ae2"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed7e9029ba48c55a028cf50c21ae6d92da41b0c58bc116f1b25623880db5a3d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31b4484cc924d0d15dc4e0533809a1d7c06a760b6cf744e8ff36a2153ee8f80a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0cb64c51685071df888b66ee265bc3f3899f6a145725ac0751f46ca8cbf865b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4309fe41d74698be8ec4752b9f6a5183835598198fecb94903cd6bc179b9e5c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a5b0952d808c8fab50b8b27e10393073765dd96961629d684009bad495a9116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a08fa66e4d472325d1d59bce2ebccaedab4bf06cc8f8b3263e2bdd0365742ff"
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