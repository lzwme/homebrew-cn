class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemaingovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.47.0.tar.gz"
  sha256 "21b4c8424d52f9c4725768a3fa9b25656e61654bf35dbc0b0ebeb8ead950945b"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00f1326daf0d4764961c14831cc9fec94cdd9b81cc383355689a183e5da3adc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00f1326daf0d4764961c14831cc9fec94cdd9b81cc383355689a183e5da3adc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00f1326daf0d4764961c14831cc9fec94cdd9b81cc383355689a183e5da3adc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3feb1a70cba6d3b52c54aff0a5cc3f78b4ac035c439b59d72f0a0c379f990cd5"
    sha256 cellar: :any_skip_relocation, ventura:       "3feb1a70cba6d3b52c54aff0a5cc3f78b4ac035c439b59d72f0a0c379f990cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "093ada8e378646f6bbc2d2f21b96b9986a418c923f21104e0ea1371eb88ec06c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comvmwaregovmomicliflags.BuildVersion=#{version}
      -X github.comvmwaregovmomicliflags.BuildCommit=#{tap.user}
      -X github.comvmwaregovmomicliflags.BuildDate=#{time.iso8601}
    ]
    cd "govc" do
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}govc version")
    assert_match "GOVC_URL=foo", shell_output("#{bin}govc env -u=foo")
  end
end