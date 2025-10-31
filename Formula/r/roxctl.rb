class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://ghfast.top/https://github.com/stackrox/stackrox/archive/refs/tags/4.9.0.tar.gz"
  sha256 "6095572514a536986b6531104d3db578896c8d427c090c54bf596881b593b9dc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbc3584f207143d35f4b0993116f94209c4c7acfff225f1f0e49857a67c07e95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9cfdcb483a2f31260fc01b712d2d2d078bf715a671c1b7e8314cd1292c35551"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23f4f751735c5ad9f29c3899523e6a19721d5a142eeaf7dbc22fbc250668d99d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dbe34c8552865dd27b90f275dc167e68b957bb900cd183ef90a942c9c33c2cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dc71d11f2fc0af5b580fe1241fca1e02499f6e9cd444dd77fdbe837c60c20a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b948eaaff62e0384ec0da59f25dcd35240ac4d8eb42e785208c3c50f654c6423"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)

    assert_match "please run \"roxctl central login\" to obtain credentials", output
  end
end