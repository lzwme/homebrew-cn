class TwoMs < Formula
  desc "Detect secrets in files and communication platforms"
  homepage "https://github.com/Checkmarx/2ms"
  url "https://ghfast.top/https://github.com/Checkmarx/2ms/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "5734a4163d332b7725adcec40cd419a10acc069306f11e48d8bac7507736b0fc"
  license "Apache-2.0"
  head "https://github.com/Checkmarx/2ms.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fce6374448482ed170a96fc0f94664c676c13acb356ca503d7154bd1842327a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949d5f3ad89d36ca81e11e51b1abc1e7cf77aabf68e139f2da0d2559dbfffb67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b3f4038fc3c93885b1fc8cac02b34dcefcbba531506519de9d1db91845ff19"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd17de243e0b8f1d92962464f3e072701342c7e2dc21045e96cabb8778ff81a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "146bf14f082d1a0e493299dc44557dffea4fce7cf68fb98222fe6ea7d10cce10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9327fa107c0dd5c7e3dc3a542116f000f49f95366907e07f517379e47c0a28f4"
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