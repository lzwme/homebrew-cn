class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.11.9.tar.gz"
  sha256 "11d5af0308bfd665611d05f188cf164efc1502c1489c0a440eed9317ed3f855c"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af453a24d577cad5b1f7f7c1fb1b7ad7d305fcc836a30012c8f929ec68617e54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af453a24d577cad5b1f7f7c1fb1b7ad7d305fcc836a30012c8f929ec68617e54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af453a24d577cad5b1f7f7c1fb1b7ad7d305fcc836a30012c8f929ec68617e54"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d2cfb14cf1f56043d0521d09a61fcf3db30b49a3c99e29626f3e752f47e24d5"
    sha256 cellar: :any_skip_relocation, ventura:       "7d2cfb14cf1f56043d0521d09a61fcf3db30b49a3c99e29626f3e752f47e24d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d685d1c84e97f46e2c3b2436f95009f6786c11942bc2da90154cd1f8641a4724"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end