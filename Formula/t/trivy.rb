class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.48.0.tar.gz"
  sha256 "3ae1fa2989b25f9b993b60169275abbb8c7eaba30f88792d0d18307db8fd85e6"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd2b756ae713669559b5fd76cbe43d9b5c65bd8acac39c445346c08fd77ad436"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b2ef30ac9efdde8c5fb5b3e394f851e95070938e275a96a86bf014f0f3ba43c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77f917a6c9198d0e718d6a8d90c9327aeb0dedad696408f256f521c7134a6ca8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fbfbf522c5a0fd1dd31b2499bef6b3e57bfe50c62f0b4edc122613a5eb979a5"
    sha256 cellar: :any_skip_relocation, ventura:        "cf62334b466886cabdc10f7952aec7b76d78e4cd9119c9ad536f0b4955a6d142"
    sha256 cellar: :any_skip_relocation, monterey:       "a00152cb994b7fed7786aee4a36807c19669658f81a26db875f0e009c925a78c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8de58bcd021a10d2c55f2f68d1ca1b51d2329c8a65eb5434d0ba632f2aa5ab2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversion.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdtrivy"
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end