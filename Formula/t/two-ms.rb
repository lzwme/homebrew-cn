class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://ghfast.top/https://github.com/Checkmarx/2ms/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "d2709b515f7f3a47cee5568249bd79073f255e04cbca9f74510e642d5d16da8a"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1c414577666f382f771183d76b0998766ce871c6d8d820a008c83df0a894afc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf1a5d2de71b45fd953bab1957eb0e30beed7907a836f18291e6e0e70b98dcae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a00988868b09962ea9b244c8856bb4de5c2f4a16acafc230367c21554fc7d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "52c50223dcfed9959ccefd57622414bea8c361e3c647f0c36e5a3aa9c31deae0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad8fd810b09173d50b85f5d2531befc5f3b0e7e72a3dd149330814054e558fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a65840a88b01b71fb3c1ceb11cfc2784325bff4a317f0aafe597298b65a2ca"
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