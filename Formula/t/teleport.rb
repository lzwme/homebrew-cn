class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv17.5.1.tar.gz"
  sha256 "ce873a2dce9b5a868fc0c92d64531905cb6c8b941acc19d6c1e39a8fe96b5e37"
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
    sha256 cellar: :any,                 arm64_sequoia: "e58994578d2915384df2d29033cff826371c8ae72e87ad8c8d02319945d3aa0b"
    sha256 cellar: :any,                 arm64_sonoma:  "ec20562b8b38ec9d6f29c257f080e239d9de893abea7955349b1062fb8245a8b"
    sha256 cellar: :any,                 arm64_ventura: "be43fb09cbccc4a66eb72325a1058bb27687073628c32c02cb1edd06ae82afb5"
    sha256 cellar: :any,                 sonoma:        "ec28f3bb43696f1f8f275fbd7620030e5b2c2b36ac52f35a6c12389668038830"
    sha256 cellar: :any,                 ventura:       "54b882bcba11d2df561f3689f10f5c6ec42ca7400655f669b268133f07395816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e27583dbf439c6d07c1d12049881f4d68ca1ea0659782c3029e3cc124bdeabfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d0e2f2d54e17d7a68e34450c8c7fdd65af5f974a1cbc5292474aaf3dacd1ed5"
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
  conflicts_with cask: "teleport"
  conflicts_with cask: "tsh", because: "both install `tsh` binaries"
  conflicts_with cask: "tsh@13", because: "both install `tsh` binaries"

  # disable `wasm-opt` for ironrdp pkg release build, upstream pr ref, https:github.comgravitationalteleportpull50178
  patch :DATA

  def install
    # Prevent pnpm from downloading another copy due to `packageManager` feature
    (buildpath"pnpm-workspace.yaml").append_lines <<~YAML
      managePackageManagerVersions: false
    YAML

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

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

__END__
diff --git awebpackagessharedlibsironrdpCargo.toml bwebpackagessharedlibsironrdpCargo.toml
index ddcc4db..913691f 100644
--- awebpackagessharedlibsironrdpCargo.toml
+++ bwebpackagessharedlibsironrdpCargo.toml
@@ -7,6 +7,9 @@ publish.workspace = true
 
 # See more keys and their definitions at https:doc.rust-lang.orgcargoreferencemanifest.html
 
+[package.metadata.wasm-pack.profile.release]
+wasm-opt = false
+
 [lib]
 crate-type = ["cdylib"]