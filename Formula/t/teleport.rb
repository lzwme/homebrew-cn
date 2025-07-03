class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv17.5.4.tar.gz"
  sha256 "da3278f47a7a3fac9787604582ddaa84e9f860a1b191f999f48948c17606895a"
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
    sha256 cellar: :any,                 arm64_sequoia: "089ccd142df27a75649fa826a225815faca65276b10189171ff373f57d44fa37"
    sha256 cellar: :any,                 arm64_sonoma:  "6c089230ae007ea2be03cb7de3b0381531de4ad5b16f4af6ee892000eeb31343"
    sha256 cellar: :any,                 arm64_ventura: "1c0e0a059c16d74cd660f66120ec63d47d7b3dffcdc5d14c586fda9107abfe55"
    sha256 cellar: :any,                 sonoma:        "47d053e812fe960b7e10a636b5e12029056b17162bf708dc14b9c6f93005c786"
    sha256 cellar: :any,                 ventura:       "d52bd8682503e484341cb747bce28e70d377d5a52a6de99685a8dde9461f5e5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc26c193f4b88e31bc84b49b24e7b05a032668444bc7545b4ccf6c95dde0f1f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e47eb04cb2f51e685377f450515625cbbccc28efeb0d0499440b4d7c17327cea"
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