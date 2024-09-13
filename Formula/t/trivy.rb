class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.55.1.tar.gz"
  sha256 "dfe18dbe98ce4edecbe15a830840e914f8234d99ac8074f7992c315a1ce98392"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3cc1d4e578ab393886f9856c499dcefcccb9a5e97cdb6d32c653f6678e9218b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af3869dd18a35cf72ef3b1f080f3b3da777c1c0d2f1757c435048ec61ac02ee6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64c77031faf570ebeceddcd24ec1f812b6136fdedf24f109e6c06f00b1c4b51a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7da7f8180dfd0a84efaa74f0ce042bfee7c86e547a1e25ada4fd0a83b774291c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4380425b9d6f754d2a848bbf6d9636fc52529e2874ad2784406646c65eb81e8"
    sha256 cellar: :any_skip_relocation, ventura:        "fbb4e2d8c62a896f3e7d60be71ef12a7c00f98af68d5f1c6b32bb81d4cfb9ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "4c320fa7b181a2cd46e1af46afb4b32187f091b8358f33ec9eb614dfc6a75f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf3e24cf775984026e12bca1c92061ff51ee3fa38449ec28c7909b21b9e2cfa6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversionapp.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtrivy"
    (pkgshare"templates").install Dir["contrib*.tpl"]
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end