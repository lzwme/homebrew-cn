class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv17.4.4.tar.gz"
  sha256 "9972b1295542425dcd5f5443e2ded35255fb19febb9afaa42e4c9095f6286be8"
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
    sha256 cellar: :any,                 arm64_sequoia: "b0218df5abf87d1f484fabbc79087635745053e8b403878aac58e0b441ef9c28"
    sha256 cellar: :any,                 arm64_sonoma:  "f75399703c3dd3ef83da8cbd550a727779c4efe1d2d5492addbb971387dee7b5"
    sha256 cellar: :any,                 arm64_ventura: "dbddeacbc3602a2adfd34e7257723e8ff27f8e5c60b8d75eac497340207194bd"
    sha256 cellar: :any,                 sonoma:        "52f524663f9eb0c1da04aa120ae397b8e46837d484152ec19075ecbd401234db"
    sha256 cellar: :any,                 ventura:       "ce6fa2606d9a8b71bba913e6541fe6313caa7f786da587b7d1bd4d13111cac8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7c40e34e27879e0591d0f578df3c225d8f55ef4703a0e71d8f26c7218bc4c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4e9e6c122fa3fdf3e8037c618b82872e4061116ac682789211c94938de1b1d5"
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