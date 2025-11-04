class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://ghfast.top/https://github.com/Checkmarx/2ms/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "cb969c70294b3870768c4b1be036e577fdec54384e2db25360c265eccaf17b3b"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00a3d4048b412ba6dfe482a03935b6f520e55f49d36c74065026ae2dd6e551e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47b55690b091fe9c8506a4fc7f8f93c680f8790f43d7fe436dfd53d2d577e50a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "146eb8814dfa484867cb4ad58f8d791b91d074c06d65c18a4fc7fdc595404af2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6840899b1e2120bbdf7864ed18787bbef2356ce4529e3e4610f567df2c1bdcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402864fc67c28ad2447ee703a890fa90d803d6c1761e85628ec129735b04e97c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b95ba06de301a613c84cf0a43052c3c5d8e42457f8b383a0174987319a322d6d"
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