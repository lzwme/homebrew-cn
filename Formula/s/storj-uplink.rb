class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.113.4.tar.gz"
  sha256 "5e99aadeaed394a3c0779642e2ea299ee5a00a4150b0940669d8dfbed8951d88"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy ifwhen
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5256589b601e7351227f5054fba179dadbb05930312ff65000212535f9bdd709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5256589b601e7351227f5054fba179dadbb05930312ff65000212535f9bdd709"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5256589b601e7351227f5054fba179dadbb05930312ff65000212535f9bdd709"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac89d03c0fca5d31ddf543cb01d72e876fff021d73d481d1ea88008966f9fa51"
    sha256 cellar: :any_skip_relocation, ventura:       "ac89d03c0fca5d31ddf543cb01d72e876fff021d73d481d1ea88008966f9fa51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e3849a2846e3f7e4c0e3b71d6b64da3c37e9875376237e0b49354fb1e07694"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"uplink"), ".cmduplink"
  end

  test do
    (testpath"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}uplink ls 2>&1", 1)
  end
end