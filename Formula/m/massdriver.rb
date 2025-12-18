class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.4.tar.gz"
  sha256 "d4e3b9ffcaebdb95c4a4eb88259294c4bda2225696ec86853caa21442039765f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "515328d741a92133655067b639e1e77b14e11c20a017ace1eab287aded608e10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "515328d741a92133655067b639e1e77b14e11c20a017ace1eab287aded608e10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "515328d741a92133655067b639e1e77b14e11c20a017ace1eab287aded608e10"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4beadbe18cb3404b91d9e789c373771fc28ccdfdb91c2e20a3d0b4a3a8ec538"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "992552b950ea4e8c50d506d03cb6589b0c267d61d489bff42f62a0011c55137f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c00ce58a4af1ccd0c84ca76b9ba02673f1aeaab1a80a6a2c06cc1de0d15e15f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end