class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https://www.versity.com/products/versitygw/"
  url "https://ghfast.top/https://github.com/versity/versitygw/archive/refs/tags/v1.0.20.tar.gz"
  sha256 "49c38f0572c28f33f0248aca894bbc1e01f69136435167fb50e628c5117c431d"
  license "Apache-2.0"
  head "https://github.com/versity/versitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ce2f54bcda1c3e92518468e93baef4531b79128ea0b60cf230d05c09ff3d696"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "601df6822b7a5afa792a0610e226d67126d8b95e7e3b63016a39e91bf346c3b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13a4568dbd29941d8d8d11294b0e442010511596a9402fb9f93748590527224d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bd19e62747537e291ffb81cdd6bfb46929264481627a12234832d89944976b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9913d6d1bd16b59141bdb2d0711ecb56021e4ced45b7df01a7141080e613786d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa5b0a54ee3d1d080d59f9e02dbbb67c8fcfa969c0bc025c9363dc940f3f68f"
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