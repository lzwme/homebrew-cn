class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https:github.comjoshmedeskisesh"
  url "https:github.comjoshmedeskisesharchiverefstagsv2.6.0.tar.gz"
  sha256 "29371bc4ced82f37cc4b4d785e3423f45d4a1415049bf66f61d9fc124d5ff3d5"
  license "MIT"
  head "https:github.comjoshmedeskisesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a82813dca10e229c3d4bfeeca54e2c8c11916a4f24f37bbba6a532bf1324a2e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a82813dca10e229c3d4bfeeca54e2c8c11916a4f24f37bbba6a532bf1324a2e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a82813dca10e229c3d4bfeeca54e2c8c11916a4f24f37bbba6a532bf1324a2e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "afa6ce77d55abf50d90046fdd299b1941fa0892eb1bb2f14c23f2c4ab05cba51"
    sha256 cellar: :any_skip_relocation, ventura:       "afa6ce77d55abf50d90046fdd299b1941fa0892eb1bb2f14c23f2c4ab05cba51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a25b4abfbb3eeacf4fd0104738e41dc7b0208ca254989b9799e507738913b84f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}sesh --version")
  end
end