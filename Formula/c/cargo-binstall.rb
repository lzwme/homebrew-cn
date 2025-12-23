class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.16.5.tar.gz"
  sha256 "102162a158dc8dec1456dd57bc2332a194615b4547a5419eaee44dafe9aec651"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d0162762b9f8ad9d68332a12338aa339d79623644a49378df2e7c873c3c1ba2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0456aa0519f0784f3ff0887484311d7c818788e81d397418105857a594f49e55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e27b5d0f045a0e5acaec3b91f2072fb269bc1f1ddf622e3f4c6d7c2de8e0897c"
    sha256 cellar: :any_skip_relocation, sonoma:        "536807fd696365058478bd67e9913bf1918defbe750c93bfb497bae807d73f01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d25aa57637d1c00d3875eaa0bc7ecf94ba6ec6869ffcf127a915a172eb8b1214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3b9aac6a8d6328aaea728e0e01ec42b630166b92d3eb03a474c03aba24f790e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    ENV["BINSTALL_DISABLE_TELEMETRY"] = "true"

    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end