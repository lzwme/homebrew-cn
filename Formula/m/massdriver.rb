class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/2.3.0.tar.gz"
  sha256 "7d8d2eea1145697256591312db5d712af198b4a1877568bff1c298bc7dc57ae5"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "731294f02f6d0f57ac7e6c3dca401989bf935e12d56dc3e8ff0c3ed75b7f803a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "731294f02f6d0f57ac7e6c3dca401989bf935e12d56dc3e8ff0c3ed75b7f803a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "731294f02f6d0f57ac7e6c3dca401989bf935e12d56dc3e8ff0c3ed75b7f803a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9783b14c0641400bfa75be883a7882ed16ce8f9049a456cc615644c2150b9b76"
    sha256 cellar: :any,                 x86_64_linux:  "267384f2b6ede9944bb995839c591056cff79f2367e458b22b809984b50a8204"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end