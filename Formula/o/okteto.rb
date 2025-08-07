class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghfast.top/https://github.com/okteto/okteto/archive/refs/tags/3.10.0.tar.gz"
  sha256 "eae12222bc550ac47d148260a91d7478f6f8633a6b936c6e0ed2dcdcbcda55ef"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e3f76a7bf8044d14003473336db083316f84b6d2c92e9f1c7f4a3b92c0741e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27071d252e567b5fcb0fc44b1f2ba80869458f770af03fb8bb6dadfdbb85dd01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c505bc6eaf68d447ddbac885e5b41246017a5001a41e1395ba4117fbc3abf7c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc047965d6a58aab9d307e03cc6be1ce661b68235d9574cd2210826f29b906e9"
    sha256 cellar: :any_skip_relocation, ventura:       "6b1029ac6ded772c4419035e344d5287facf5ffaf495e66df4eb68b7e929c61c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72a5d263286cc5ee66e9138ebcd05b02fc2592325b3b5b00c3d8afb363aa75d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c35ec1f58987de1a16d6259836a4d6c54ac592af3dc20c7f04421a887e8c0453"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end