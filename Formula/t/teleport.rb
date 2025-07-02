class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv17.5.3.tar.gz"
  sha256 "2ab2421fa761647ae044f26b65a6133732e8368d0302c6bb8bb25c9479f7d3d4"
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
    sha256 cellar: :any,                 arm64_sequoia: "6242112e126def231dfd6e8d744f44e8ead093853fca3b4324b452bc2936dc7c"
    sha256 cellar: :any,                 arm64_sonoma:  "bc702f6cede21621af842240e6c1d83679b136dd960cb95671dc890d1bc5b629"
    sha256 cellar: :any,                 arm64_ventura: "2b8c5d3b2b6f7f6fe430af8c24e28a0344fd453bc604cc28501b14fb4dcdddef"
    sha256 cellar: :any,                 sonoma:        "35a0cb8e6372832e6027f0bb3c01603f148de069e42d6d40c0deb73136056603"
    sha256 cellar: :any,                 ventura:       "5b91fe3187d1ba9646314ff2bdb225389e692b6668021b7339693f38cdfb99ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cddb8ab7e3fd3cc948bac7dd392730af9fbd5b1f1a70f5901946cc2391b38939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d15272d3872bcfbc55ef9f59fda19d8930583542c80f548d2e5d703195ec534"
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