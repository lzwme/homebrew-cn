class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.73.1.tar.gz"
  sha256 "edf1b6e307a9653794e92be3ac23a2cd28f17f25eac3efe3350d693a2c8d3b19"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "574b2ac550f0c5390e2128c2e58e48e01a766fb2cafef2632f0cacdda590f3d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5925ccfa69339e01de4ed1e0d8e7c087780d93aefadded6e4bf5366112e46fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a325d0249eb89075b3be56aa888c01975a03e11eb4e300693a6a8bc4fceb318"
    sha256 cellar: :any_skip_relocation, sonoma:         "c244fff69f1e261f8fdccf2e6fa34e112c16961579f358631fce94cc452b1b29"
    sha256 cellar: :any_skip_relocation, ventura:        "f9d78eb3f97becd04c49ee3627f305ec205d8e198174f060bbe5a8cfca465843"
    sha256 cellar: :any_skip_relocation, monterey:       "a295d8baecd71cef2dec94f5a54cc7489448780d88f5171405b2b078392af953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b0b0571c3895b33d7141d7c0682007ec71269e1ef68d113ec331f0d2ba0e401"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end