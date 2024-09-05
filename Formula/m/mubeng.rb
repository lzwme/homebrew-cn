class Mubeng < Formula
  desc "Incredibly fast proxy checker & IP rotator with ease"
  homepage "https:github.comkitabisamubeng"
  url "https:github.comkitabisamubengarchiverefstagsv0.16.0.tar.gz"
  sha256 "78cac90976e4555d379346496655a634a9bbf21b12b978f890c66f4c870afba9"
  license "Apache-2.0"
  head "https:github.comkitabisamubeng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0198b55b442b7e4b9201196ebfe7be547f18be66ee32a3b4f210d4a26f4be369"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0198b55b442b7e4b9201196ebfe7be547f18be66ee32a3b4f210d4a26f4be369"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0198b55b442b7e4b9201196ebfe7be547f18be66ee32a3b4f210d4a26f4be369"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e5babf80e847fd3c716617a2fa3fdbd9c0b48d01ec14ebcec745ff060fe9687"
    sha256 cellar: :any_skip_relocation, ventura:        "1e5babf80e847fd3c716617a2fa3fdbd9c0b48d01ec14ebcec745ff060fe9687"
    sha256 cellar: :any_skip_relocation, monterey:       "1e5babf80e847fd3c716617a2fa3fdbd9c0b48d01ec14ebcec745ff060fe9687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce7bc8b6c6051bc84fa5decf3a034ef90298ffa9f8616147d4c41151c94b5232"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comkitabisamubengcommon.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdmubeng"
  end

  test do
    expected = OS.mac? ? "no proxy file provided" : "has no valid proxy URLs"
    assert_match expected, shell_output("#{bin}mubeng 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}mubeng --version", 1)
  end
end