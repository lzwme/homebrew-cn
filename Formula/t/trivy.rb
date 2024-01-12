class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.48.3.tar.gz"
  sha256 "ff41f676762ba6fb52604705b4305541c0a695f167f036cfdb71ca1efeff229e"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6afc7dc1a184d8314f6bc43102f934bb44e7281bee2010a122664b66d10de00a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5f1e455530261f210adb323f8ff7925ca0b42fd622560812de4d7a40407f654"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42f839a3a2388abaeb153470d5d63d8e677dbc97f82caa31ca5a652c06be06b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c0ff4394eed3874695562adebbed9f57d1dd4febaf72f8e5de07d886e3bf0a6"
    sha256 cellar: :any_skip_relocation, ventura:        "32924f04a6b0ad980c806abf0b7d55e1e32e53a18153e7ca845684d0d2b4a20d"
    sha256 cellar: :any_skip_relocation, monterey:       "56e14d5b6b14fc13456f4b62ffcf9c9b9197713b2c1ec99c7b4f1181fdfcb282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea55c476f32ed5f46fa09d3f943b62b2c1519b323216e0a1c9b9483edc382cd7"
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