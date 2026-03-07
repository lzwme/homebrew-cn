class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://ghfast.top/https://github.com/Checkmarx/2ms/archive/refs/tags/v5.2.3.tar.gz"
  sha256 "d4fe2e1d66f3a933581cdac99569b4cf3da7865d58e4dff8a753b86f0aea8d00"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dde5977e8633d75c1efa06d67aa9441fc1b37452258b7257e3577e00f998acfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7340ec4acec3c57bc12880051d58c063ee2900ee8546be3cf87af53ae7eb5184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d428d5f1c4ee124f712aa32ea6603851bbb8d1a4d416d274c213147155fc387"
    sha256 cellar: :any_skip_relocation, sonoma:        "caa1b7207640d671640abd8775ee7bd82f93da080c9a3028a95aaa1b76c97d46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "286ca58d74e273e0843eb275896c67c68b17aa3316ae6208c874dcfe0ff6955c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9dc0f41b76d76d14596b0249f1d717fd0a64091aa3c8d5119bffa720dfa91ef"
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