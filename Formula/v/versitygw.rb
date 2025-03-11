class Versitygw < Formula
  desc "Versity S3 Gateway"
  homepage "https:www.versity.comproductsversitygw"
  url "https:github.comversityversitygwarchiverefstagsv1.0.11.tar.gz"
  sha256 "ab4717239a1ba5eb9a8da5ec841a3cb0e8698d303d9f01c1ea575fec12a6e90a"
  license "Apache-2.0"
  head "https:github.comversityversitygw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75c3c7fef24e70ae4a3f203187ff62119000f9d6a3663e1da1752a9718849e7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75c3c7fef24e70ae4a3f203187ff62119000f9d6a3663e1da1752a9718849e7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75c3c7fef24e70ae4a3f203187ff62119000f9d6a3663e1da1752a9718849e7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1ad79903d9a531b4a842f98e6a9a7204299e8dcb0e5906a0945bc3f5e8e36df"
    sha256 cellar: :any_skip_relocation, ventura:       "d1ad79903d9a531b4a842f98e6a9a7204299e8dcb0e5906a0945bc3f5e8e36df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47c3e109a27f2c62d054f7393dabe1187b41cb89ef7f5e987ad1c9cb25b33f60"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601} -X main.Build=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), ".cmdversitygw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}versitygw --version")

    system bin"versitygw", "utils", "gen-event-filter-config"
    assert_equal true, JSON.parse((testpath"event_config.json").read)["s3:ObjectAcl:Put"]

    output = shell_output("#{bin}versitygw admin list-buckets 2>&1", 1)
    assert_match "Required flags \"access, secret, endpoint-url\"", output
  end
end