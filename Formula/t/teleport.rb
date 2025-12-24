class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://ghfast.top/https://github.com/gravitational/teleport/archive/refs/tags/v18.6.0.tar.gz"
  sha256 "6dd393fd7f8301be468ec5f9b9a9dbee50259f396385dd9b61d5470de3b245cf"
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
    sha256 cellar: :any,                 arm64_tahoe:   "f6face3615798814237ca294c99b77b9ebdf49f37a285299612c6ed811c863a6"
    sha256 cellar: :any,                 arm64_sequoia: "b895f97ac3241b36cfcf83b28aaf4fa0c814e574673ce65cb40a636bf249d0e5"
    sha256 cellar: :any,                 arm64_sonoma:  "bb84d67558aaf8045eddbccf0575c65bd7cb5b9ff40bffde11501ac7591739c5"
    sha256 cellar: :any,                 sonoma:        "24e9e23e5debaaef99e6785b2169d38653be0263a75f0f24e43ce4d5280e7301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70502bd7d57392aae8727dbc123f0fb7df6ae41f13f76b004ca157058c3f93ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77fb1831f4f42e2ef70e317c4899e3332691cccba3b1d1a614b6a96057059aa8"
  end

  depends_on "binaryen" => :build
  depends_on "go" => :build
  depends_on "node@22" => :build # node 24 support issue, https://github.com/gravitational/teleport/issues/57202
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  # TODO: try to remove rustup dependancy, see https://github.com/Homebrew/homebrew-core/pull/191633#discussion_r1774378671
  depends_on "rustup" => :build
  depends_on "libfido2"
  depends_on "openssl@3"

  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"
  conflicts_with cask: "teleport-suite"
  conflicts_with cask: "teleport-suite@17"
  conflicts_with cask: "teleport-suite@16"
  conflicts_with cask: "tsh", because: "both install `tsh` binaries"

  resource "wasm-bindgen" do
    url "https://ghfast.top/https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.99.tar.gz"
    sha256 "1df06317203c9049752e55e59aee878774c88805cc6196630e514fa747f921f2"
  end

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

    resource("wasm-bindgen").stage do
      system "cargo", "install", *std_cargo_args(path: "crates/cli", root: buildpath)
    end

    # Replace wasm-bindgen binary call to the built one
    inreplace "Makefile", "wasm-bindgen target", buildpath/"bin/wasm-bindgen target"

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