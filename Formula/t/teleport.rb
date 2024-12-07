class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https:goteleport.com"
  url "https:github.comgravitationalteleportarchiverefstagsv17.0.4.tar.gz"
  sha256 "9b3f938feae10d6bdd1ab4fb5e15256d49f02d927a24ad76ac044003e1d7bf57"
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
    sha256 cellar: :any,                 arm64_sequoia: "5f81c3a8051a3eac1d24b8d006fa9e108df1f6f41477a6804aedb3f9b410d80f"
    sha256 cellar: :any,                 arm64_sonoma:  "70e45c8ac6a8803edef1008f61eaead2466b9274648c8f2fd9a81cd82bc78cff"
    sha256 cellar: :any,                 arm64_ventura: "4152e34a718cf9a20d7e07126ac5011abe3b468b6db3c4294e3cfac1c4959ebf"
    sha256 cellar: :any,                 sonoma:        "717a091f921d00b66bc64b0ca8d9e5c423a18e026d74559bffa173b3e6389186"
    sha256 cellar: :any,                 ventura:       "6a02dfc05450527d8d68d3b98a59b45399ee9a49d8cd052ccb87e8ff0ce26390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d67a27ee8ea0c58bff278ee943ab91438ccd97438d9cc43b82900f774cf45f"
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
    (testpath"config.yml").write <<~YAML
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}data
        log:
          output: stderr
          severity: WARN
    YAML

    fork do
      exec "#{bin}teleport start --roles=proxy,node,auth --config=#{testpath}config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https:localhost:3080"

    status = shell_output("#{bin}tctl status --config=#{testpath}config.yml")
    assert_match(Cluster:\s*testhost, status)
    assert_match(Version:\s*#{version}, status)
  end
end