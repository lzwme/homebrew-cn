class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghproxy.com/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.9.tar.gz"
  sha256 "1625f5a0d9dc28b9d03753b3c3930cd5041a61dca0abb0cb50e4ac9b84839e65"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f73c0dbfe97fd306033b2c966fdc80c9f9afa8b9e004141097cb3f07feabfd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fca1c2b08ace437db27f94b66dfa74e84ac6ca756902dea0b96b28a4eaac3ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06943c7c2c24e1f518a0527fbe8bdcdb19a66c37776ded2b8d740978b712dc68"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7743fccbe7a722563894652d31eab1821efdf716fc420a7bad5ad09da92b28b"
    sha256 cellar: :any_skip_relocation, ventura:        "a7a87f33a823bcdd5606d69d53445ad42f9659ded1112b89352983ffde7b6782"
    sha256 cellar: :any_skip_relocation, monterey:       "6916663410faa53aab61d8c3e74c4bd4138b3773e4f6a97bbffcf28257e8fe27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "426303982166ed3e78f4884dcde34f56567fadcf2b4e9de8467d3e1b29fdf82c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end