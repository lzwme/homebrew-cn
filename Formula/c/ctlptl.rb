class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https:github.comtilt-devctlptl"
  url "https:github.comtilt-devctlptlarchiverefstagsv0.8.39.tar.gz"
  sha256 "d9f5b608c8aca1dc14532d97c1c16e88d618a42bb0d7c2718b36bdb80a173b9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a5edcfdb65d6733f7f674793ea4c5e3823e396365705f22cc4d69dbb20c0ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76a4be0c3c6c98bb2b927636904e229d508ec88ca55fb8b465a5df6b7e340ecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0724d14120ba834159877fa03f6b271b730f6d1529fdc66dd7f03f2e3322eb3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "78fca78e473f5d4283979c30fb722984fe3033fb33170cfe52d01e16ea74ffc6"
    sha256 cellar: :any_skip_relocation, ventura:       "bd7e14127f1e2bf2f55f8242084885715c02ad6f3c9471d9b7f33960a489bda8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "314f0f8bafd4bd8191bb6d4e54294a1c2ad30eaaa8492287949df292c905eef6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdctlptl"

    generate_completions_from_executable(bin"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}ctlptl version")
    assert_empty shell_output("#{bin}ctlptl get")
    assert_match "not found", shell_output("#{bin}ctlptl delete cluster nonexistent 2>&1", 1)
  end
end