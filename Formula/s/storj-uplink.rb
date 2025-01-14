class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.120.3.tar.gz"
  sha256 "2eaa9ee583046f7bda4f7bb603192bde1324f86c917ef800248662f64093fde8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db03a3e3fd21091b158d48015a1baae25d43a5bdfe8ac80b45092e5e04751831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db03a3e3fd21091b158d48015a1baae25d43a5bdfe8ac80b45092e5e04751831"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db03a3e3fd21091b158d48015a1baae25d43a5bdfe8ac80b45092e5e04751831"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc2035cee94f532d67846b78c784f10cb6894ce131394e94549439bbf3b7608f"
    sha256 cellar: :any_skip_relocation, ventura:       "bc2035cee94f532d67846b78c784f10cb6894ce131394e94549439bbf3b7608f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da0b963516b8af5d90adb46de47de4c94cd684b8497c79e6cc7eb3c2ba491af6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"uplink"), ".cmduplink"
  end

  test do
    (testpath"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}uplink ls 2>&1", 1)
  end
end