class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv17.1.3.tar.gz"
  sha256 "aead2a59620d28db48e269c86ea4c7c3180c0b5f5c861fc116b5dfec2af1c2de"
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
    sha256 cellar: :any,                 arm64_sequoia: "5e91bfb854c8efbe47a7e700ab031bfadcc7aba225088a23ec93f80d866d64f3"
    sha256 cellar: :any,                 arm64_sonoma:  "e60c9179404c814c3c98e3d7e31fbf13ddf19a67f3f6781d5c0255ac82b0054b"
    sha256 cellar: :any,                 arm64_ventura: "82f60741a9bfe11922c388dd695d21907464f9fdbf3b15f335750913f4c18f25"
    sha256 cellar: :any,                 sonoma:        "1a26d22f996c5c4f0b6991615bc2c404a77685e71939f7f4844df3e5833bf287"
    sha256 cellar: :any,                 ventura:       "4bf86aefdac74bff530a2b6d4ae87eed4afa340b82895e74a747dbbd51c56eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80c236c81adcb091b1bb0e45f1bdc8c4ab8caf013de4bad15cf5bfcb12522098"
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