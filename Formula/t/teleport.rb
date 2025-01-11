class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv17.1.5.tar.gz"
  sha256 "c8fec309d9daba3691052f4b29bd9b7a39fb9df6d39987af3d8cb2dac6cabbd1"
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
    sha256 cellar: :any,                 arm64_sequoia: "19f9c9b95116addc5fc419ef3eae883dea4a15595a5f0605e0acc4691bfaca4a"
    sha256 cellar: :any,                 arm64_sonoma:  "a48bf8f1107f119edbc5850751073ae6ba288a9c0acff5b7ef139512caf47a0d"
    sha256 cellar: :any,                 arm64_ventura: "2220f4263ac818e699be8191b30ce54acd9ea54bd44570870895df568d8a497b"
    sha256 cellar: :any,                 sonoma:        "7c18b0c3adcd2068a798f87e181d12149de8898523347e59b97dc1454e71f7b9"
    sha256 cellar: :any,                 ventura:       "cfb8c92d25ef0dae0366984abbc5f20589eab15317d17b6efaa97a3d539768ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92d4c820d60fb484e0c5e1382e96de14bd2aed654abf509e4285b9d70e150179"
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

  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"

  # disable `wasm-opt` for ironrdp pkg release build, upstream pr ref, https:github.comgravitationalteleportpull50178
  patch do
    url "https:github.comgravitationalteleportcommit994890fb05360b166afd981312345a4cf01bc422.patch?full_index=1"
    sha256 "9d60180ff69a8a8985773d3b2a107ab910b22040e4cbf6afed11bd2b64fc6996"
  end

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

    spawn bin"teleport", "start", "--roles=proxy,node,auth", "--config=#{testpath}config.yml"
    sleep 10
    system "curl", "--insecure", "https:localhost:3080"

    status = shell_output("#{bin}tctl status --config=#{testpath}config.yml")
    assert_match(Cluster:\s*testhost, status)
    assert_match(Version:\s*#{version}, status)
  end
end