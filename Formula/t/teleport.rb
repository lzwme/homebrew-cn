class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv16.4.0.tar.gz"
  sha256 "fd8d0fe968bd863e3657e0cdfe7d3a5e90b0663b1efe396802f1880d2a6dde79"
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
    sha256 cellar: :any,                 arm64_sequoia: "655ed41855aadea238493f847ed5ef38031773656a73e703af59b967a6993e0f"
    sha256 cellar: :any,                 arm64_sonoma:  "7c1a8dfcb8206e79aa19887f46bbd91d8076d380e2a30daa7adc5a04359ec77d"
    sha256 cellar: :any,                 arm64_ventura: "5138439b1b1930de2b6635ccefc6f274076d566a6e2470efd0bebaa5a053e412"
    sha256 cellar: :any,                 sonoma:        "2470914809568d757d5e3ed065feaef37571636bfce8b407c39ff996a1fa8aeb"
    sha256 cellar: :any,                 ventura:       "5f28fc33e1f52fe77279855ef1d14ac8025b08301a910d1ebabf559f9e694bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0390a3014408096fdc6b1dfe66df9376edb4d9af86f053ad2d37276932d34280"
  end

  depends_on "corepack" => :build
  depends_on "go@1.22" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
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