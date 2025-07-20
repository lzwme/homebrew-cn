class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://ghfast.top/https://github.com/getgauge/gauge/archive/refs/tags/v1.6.19.tar.gz"
  sha256 "e56aeaae3686bbb0cecd2f4e6882b40cab2870b0d2f8843660b68b5faa65a6ca"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f289ba1acbdd50c6aa697eea7d6e25f9baeaca90c6c5424276d8bc5dd2a1e857"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64b353a9591c6d5d35f622781d5f4d8538caa3e7c7af292061a07b3976822e02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f475159d46499395448445c1e40cc244a9f99004794567b8c1f0e0f14404ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "722ad50cdcfa962dccb9588c03e9aaa892c63b6520b3c636f783759362d0d454"
    sha256 cellar: :any_skip_relocation, ventura:       "d3a96755c685429db04990dbb057f714cd1c8067a194fecc35230dbaaced5fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68dd039947b5150bf8121ef573a9b4d39f6ca29f0ea2c23ec0335b922c463429"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin/"gauge", "install")
    assert_path_exists testpath/".gauge/plugins"

    system(bin/"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end