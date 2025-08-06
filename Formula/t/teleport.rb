class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://ghfast.top/https://github.com/gravitational/teleport/archive/refs/tags/v18.1.2.tar.gz"
  sha256 "86d8050673ab02aab3a21714a49d7f48efe0470c98ee617267241a77b077b375"
  license all_of: ["AGPL-3.0-or-later", "Apache-2.0"]
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version,
  # so we can't use the `GithubLatest` strategy. We use the `GithubReleases`
  # strategy instead of `Git` because there is often a notable gap (days)
  # between when a version is tagged and released.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a664bdda1a252b67998c85d1dba8ee16eb6cf6e663919d1fc60f0b95df70ee67"
    sha256 cellar: :any,                 arm64_sonoma:  "c7e641e944211f57d7f228ad30383104c1a01f1cc37048cc47af3e78635c00f2"
    sha256 cellar: :any,                 arm64_ventura: "714a54da61d4ca80e785dc0fe7eceae77430d78b18ed6c2c481e3434d0210efb"
    sha256 cellar: :any,                 sonoma:        "3592c84e808fcdf8eae595a5f92d56fcb3544b8cbbac1f803e896987800f9577"
    sha256 cellar: :any,                 ventura:       "5ba4b5943dd71eabd929b5d3ccc78c7ad11d5bd228f60291248bc63d2c336aa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "504f78a3c23bf1afe29307ddb89157110ada89cb1aa0ab57590ed6f96b37f8a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2fbc32586553e21c75528fe01b7d0cd6fadfae0da4059540014a12249ca14d6"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # node 24 support issue, https://github.com/gravitational/teleport/issues/57202
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  # TODO: try to remove rustup dependancy, see https://github.com/Homebrew/homebrew-core/pull/191633#discussion_r1774378671
  depends_on "rustup" => :build
  depends_on "wasm-pack" => :build
  depends_on "libfido2"
  depends_on "openssl@3"

  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"
  conflicts_with cask: "teleport"
  conflicts_with cask: "tsh", because: "both install `tsh` binaries"
  conflicts_with cask: "tsh@13", because: "both install `tsh` binaries"

  # disable `wasm-opt` for ironrdp pkg release build, upstream pr ref, https://github.com/gravitational/teleport/pull/50178
  patch :DATA

  def install
    # Prevent pnpm from downloading another copy due to `packageManager` feature
    (buildpath/"pnpm-workspace.yaml").append_lines <<~YAML
      managePackageManagerVersions: false
    YAML

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~YAML
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    YAML

    spawn bin/"teleport", "start", "--roles=proxy,node,auth", "--config=#{testpath}/config.yml"
    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl status --config=#{testpath}/config.yml")
    assert_match(/Cluster:\s*testhost/, status)
    assert_match(/Version:\s*#{version}/, status)
  end
end

__END__
diff --git a/web/packages/shared/libs/ironrdp/Cargo.toml b/web/packages/shared/libs/ironrdp/Cargo.toml
index ddcc4db..913691f 100644
--- a/web/packages/shared/libs/ironrdp/Cargo.toml
+++ b/web/packages/shared/libs/ironrdp/Cargo.toml
@@ -7,6 +7,9 @@ publish.workspace = true
 
 # See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html
 
+[package.metadata.wasm-pack.profile.release]
+wasm-opt = false
+
 [lib]
 crate-type = ["cdylib"]