class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv17.2.7.tar.gz"
  sha256 "388b5353ab13bb423d9dc038c5c7b86841a83c38a5fb9820aa1415cdf2b1a0a6"
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
    sha256 cellar: :any,                 arm64_sequoia: "2695fd5ff7744716cdbb6c4d5ecbb97d19f2e48e96d687334fe0c87e0662fac3"
    sha256 cellar: :any,                 arm64_sonoma:  "93d16457a8f7b82288b448d96542b96db1e1d796e1950445c2aab407c3fc98b8"
    sha256 cellar: :any,                 arm64_ventura: "8c414130629bee6a2d60b936ad28601ac4355394c8ea9a90e3efd56a806bf1ff"
    sha256 cellar: :any,                 sonoma:        "d6a6278f5c7491c4af5d2f3a5e2038b62ec01bfe004bbcf556050a4b40e28a07"
    sha256 cellar: :any,                 ventura:       "6ac6c0b733d9f9c20a61c0aaed7763ede441d589119463492777b85510a24760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72f95572189300e02c44acfb0fce2062d5f387708080cbdc5f53943ed542a5a6"
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