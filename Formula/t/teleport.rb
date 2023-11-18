class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/refs/tags/v14.1.5.tar.gz"
  sha256 "2025c8e580c74c0450f7bb4b67389e3804538061ff9a35d022e71e86212a9c8c"
  license "Apache-2.0"
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
    sha256 cellar: :any,                 arm64_sonoma:   "33042a47105fc44c3606df0bdccf9a54c52f736d473d32c6c3c7f015544b04be"
    sha256 cellar: :any,                 arm64_ventura:  "6958132260ce7d04758a716cfd6d60791e33d01274584da9de33ee2169e8a8f8"
    sha256 cellar: :any,                 arm64_monterey: "409b79cb557aa5cf3a3df596b64b730b8e5053ae9dfeb3c911efaba9c3fb3f50"
    sha256 cellar: :any,                 sonoma:         "f8ebcf8c55e86256881484eb8e740296e0f5c4285bd02f3c11d80843de6b3d98"
    sha256 cellar: :any,                 ventura:        "8cd018985d6b8beabf8946457c1803522ddd0aa45e99222ef0ab5f4d83b3017f"
    sha256 cellar: :any,                 monterey:       "e859d6e15e166232078275d1cdecc2ae98b3d33d0fb33f8420086309ca46eaf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "564be3645f772c80133e772223c37dedec9a9e8540f6e6725642bfe1bda9a51b"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  def install
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end