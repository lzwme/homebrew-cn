class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv16.4.6.tar.gz"
  sha256 "4c8b8f48c58649441502cf11d675036561ecf6a407351bc204af50ec6e5973f1"
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
    sha256 cellar: :any,                 arm64_sequoia: "0c4918f4f741014fa82f5f1e267863f38b04b3e62fa1a75458cd92e60b95d6bd"
    sha256 cellar: :any,                 arm64_sonoma:  "890427e93fc2a97fb40ed7219288b62c3ac4eac0df365cdb4735ef2fe5473f24"
    sha256 cellar: :any,                 arm64_ventura: "7b23cd79f65acf7a2a3e06fd7e1e44bec627f0551acdc65f2eedfa9a91a48438"
    sha256 cellar: :any,                 sonoma:        "560333dd05ec9f53cdc381ff704a7a2dd9072a3828d1dc11c16b20f788514b24"
    sha256 cellar: :any,                 ventura:       "eaac7023290fe2ea193358cba07ef0167349fd23f0c2cc449e39f998e402d3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e36eac1d5423401cf7412fe0538ac8c846f998bd58627a7ac844ca6167e4b70"
  end

  # Use "go" again after https:github.comgravitationalteleportcommite4010172501f0ed18bb260655c83606dfa872fbd
  # is released, likely in a version 17.x.x (or later?):
  depends_on "go@1.22" => :build
  depends_on "pkg-config" => :build
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
    (testpath"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}teleport start --roles=proxy,node,auth --config=#{testpath}config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https:localhost:3080"

    status = shell_output("#{bin}tctl --config=#{testpath}config.yml status")
    assert_match(Cluster\s*testhost, status)
    assert_match(Version\s*#{version}, status)
  end
end