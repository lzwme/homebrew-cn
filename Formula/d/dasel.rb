class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghfast.top/https://github.com/TomWright/dasel/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "8e0c20898ccf24ac9ca2217dec21bc4e0f6a17949431756ea0bce94d55d0cd43"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d1a43143567c60c5d7b82ccde34b3f325703121d100996721ab16e923d378c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d1a43143567c60c5d7b82ccde34b3f325703121d100996721ab16e923d378c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d1a43143567c60c5d7b82ccde34b3f325703121d100996721ab16e923d378c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0eb540b3fb50cb7eb218abd8a3c22c1883e7aed7ade905fce4082fb2762d3c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e7185b8d75ff0d94fb12bb667ce4ca56188985d810ebd5e2a04371b06c2c41f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f14f48f6b23fe44392accfb0bfd6561b4d4d9ae0f50124024cb6fa1ea35d713a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -i json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end