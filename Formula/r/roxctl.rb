class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://ghfast.top/https://github.com/stackrox/stackrox/archive/refs/tags/4.8.3.tar.gz"
  sha256 "f8aa3859255af0fb8ed4fe2c282cc3e1b3b23a96ca3a951a73b839cca32c4899"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda5a9dd6a12b4ba62684d70bf05c3b2629496574a8e77cb8296ee251eb78c26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd0a0ebb21f2273a33baf318910acafc07673dcb2ba2767a13f5ee37e46b25f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c4fbec24662b42501c2bf55b85f16e4b4d7a00a67ed62cf882aa9ab2b392908"
    sha256 cellar: :any_skip_relocation, sonoma:        "936cae44389800f8916c75481684a97026676c3fdf1d8b68d98038a69914bead"
    sha256 cellar: :any_skip_relocation, ventura:       "244ec288c9c1b6a86d95b633f83e8f8ae18a083a12eb6d21bda30c72913d0d2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92bc2064eed141ff5222bade341c22cddd89a655932df2326efcfe3d7815aa3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4cc57e4fe9927ca2ab18c40bd2a093a4550dbef6524bab4c997fbb2d433d490"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)
    assert_match <<~EOS, output
      ERROR:	obtaining auth information for localhost:8443: \
      retrieving token: no credentials found for localhost:8443, please run \
      "roxctl central login" to obtain credentials
    EOS
  end
end