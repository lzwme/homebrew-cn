class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://ghproxy.com/https://github.com/safedep/vet/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "fd245e74f693eb6a4456627cdccce19ea59af3cba4b84e3fc6a53334076b51fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27819ac98c4a9281e243dcfeb1c9fa34b8a13ef00856dbd14b375b8aaabc7f03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8afbb76ab9b0fa1a0ce06e425eee2701d80fd33c760ca525f950c4d751d0576"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f86f69bede826312918a4fb676cd113a89f4397569d00d2b07d607a3ac2a30b"
    sha256 cellar: :any_skip_relocation, sonoma:         "12f6a51d194302f09123bfeccb0a37caa601c3953c68a63e0f1dfdcff410ef77"
    sha256 cellar: :any_skip_relocation, ventura:        "7be72d0fabdec3341c6624425af512bc4992e30745bb6e5614e90cc04e619b80"
    sha256 cellar: :any_skip_relocation, monterey:       "6b4d428c26d9e2b9e8cd8ef77de9a2cfe5be0c182cb71412d8f25584ab411a2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60c08f7340cca0873b8015f8b9cca6f2d8554c4a2f3f1a4d91c569810e35e537"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end