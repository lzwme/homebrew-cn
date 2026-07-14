class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://ghfast.top/https://github.com/getgauge/gauge/archive/refs/tags/v1.6.34.tar.gz"
  sha256 "06ca39be180e1fe48c0fddd296ca4e2cc9e141411d6c2c206c10765d9157d9f6"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3127384715fa5c64a721930c0e7f8a3668b818a14545e77ae270a9e54a10fd61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a98bcb5eb6d33ae21aed1b8fe6e1fc24582298a3df3cfc98db40fb5fe629e187"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cdbedcdb1707ef4554e405b0a9aa7ab45ce26576764f8ecb233100cc2038659"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e49587475855e528e6a576a539f2648bfa2d82abba23ee26bce5f26922c732"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bac96c163f7308b3dd080eb27459470c9344166651929c6db71b2dfdb213d876"
    sha256 cellar: :any,                 x86_64_linux:  "1c2319aaf96734b3f4de73828cabe12bd6cd144eb5740aef4a23a4d58e619a93"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix

    generate_completions_from_executable(bin/"gauge", shell_parameter_format: :cobra)
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