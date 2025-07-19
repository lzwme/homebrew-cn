class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://ghfast.top/https://github.com/versity/versitygw/archive/refs/tags/v1.0.16.tar.gz"
  sha256 "d652720a93855167f3bef39f64612d3088b5fade1d210f1988e24bc5f7f962fe"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ef1c36b5c7034722d3d333636985fb3569d150c47d76a8484a8f5636755d6d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cddb665d8aa86bda2330bf67acdbdcee3d76e3f9476e4846ec27d44b8ee12ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b06e690ac662a966f6295baa2ddaaf9d81c853d5c95b5e5af2e3ca3371935da"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f6303325581ee003ed47ca11574feec7326c3449a2366656f652c29416ba8ec"
    sha256 cellar: :any_skip_relocation, ventura:       "b7210a9729918ab66abde59fb92469c75007b4646dda424a70d2fbe41070f78c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2b49ddc3b51de9436d45af8a4243f8e78837a15e1b48e85712b7fdacfbd2476"
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