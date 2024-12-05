class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv17.0.3.tar.gz"
  sha256 "dadd7bdb7d58131fd25ab0cad687dc450dfb6b77fe668d051942b7a86ad2e0dc"
  license all_of: ["AGPL-3.0-or-later", "Apache-2.0"]
  head "https:github.comgravitationalteleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version,
  # so we can't use the `GithubLatest` strategy. We use the `GithubReleases`
  # strategy instead of `Git` because there is often a notable gap (days)
  # between when a version is tagged and released.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "657ec314ed54a760dd797e310c7c08a75b5838a101b98aac3623acc73d513510"
    sha256 cellar: :any,                 arm64_sonoma:  "f5e43c1396fa696625ab8e664abd60d2db03ee68611ea13fc6c2bdf755c6601b"
    sha256 cellar: :any,                 arm64_ventura: "39bb8d69a54cc5daaa4d2049b9447b37b3b149d106869aae237da1eceb2bcf9a"
    sha256 cellar: :any,                 sonoma:        "b098290a883fde5341552e702fd1bc432d20990c8086f895fcccca74abbb4b00"
    sha256 cellar: :any,                 ventura:       "53aa655c4ba0b9dce16c0290eecb65fb1aa3a6409b0a1068011fccf9f42008d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "978d23d42b2209e6c29175316ab288e2363068a0bfea088f043f27f7066e638e"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  # TODO: try to remove rustup dependancy, see https:github.comHomebrewhomebrew-corepull191633#discussion_r1774378671
  depends_on "rustup" => :build
  depends_on "wasm-pack" => :build
  depends_on "libfido2"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"

  def install
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "stable"
    system "rustup", "set", "profile", "minimal"

    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}teleport version")
    assert_match version.to_s, shell_output("#{bin}tsh version")
    assert_match version.to_s, shell_output("#{bin}tctl version")

    mkdir testpath"data"
    (testpath"config.yml").write <<~YAML
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}data
        log:
          output: stderr
          severity: WARN
    YAML

    fork do
      exec "#{bin}teleport start --roles=proxy,node,auth --config=#{testpath}config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https:localhost:3080"

    status = shell_output("#{bin}tctl status --config=#{testpath}config.yml")
    assert_match(Cluster:\s*testhost, status)
    assert_match(Version:\s*#{version}, status)
  end
end