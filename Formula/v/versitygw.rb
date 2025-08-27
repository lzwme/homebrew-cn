class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://ghfast.top/https://github.com/versity/versitygw/archive/refs/tags/v1.0.17.tar.gz"
  sha256 "97e2878ae6a350820eeac3b6e7730b5fe9dbce36b916fd641a5088e1c3c11814"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88f91e873504b033fe97d57e936d4d57b6cd8d5d5e3d9f97a86d0dcd62f21087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4483bc3a518b64abc64c268dd93809cede5e46b4b2b3043503fe3ff10cdc11c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af441966e77ef40893eba280bf9d29bfcc897a44de3757c71115200c5f9ba1da"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce511156e5132d018109305dd0032295ae54c828c85ded3cc19b19d91a24a732"
    sha256 cellar: :any_skip_relocation, ventura:       "183f8fb23d815febad6adf6becec9e5287c904ad6e6b1b0ecd2024350e90e58c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5997f33228c8a48ce5747d0399077232618178ae9b5205d90c831f3a628f634"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601} -X main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/versitygw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/versitygw --version")

    system bin/"versitygw", "utils", "gen-event-filter-config"
    assert_equal true, JSON.parse((testpath/"event_config.json").read)["s3:ObjectAcl:Put"]

    output = shell_output("#{bin}/versitygw admin list-buckets 2>&1", 1)
    assert_match "Required flags \"access, secret, endpoint-url\"", output
  end
end