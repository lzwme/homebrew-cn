class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.146.6.tar.gz"
  sha256 "558b7de2172a88a957f90616c51082eda3e8b3fc0c39ee0df2bbce43fd07f52e"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7ad025e35454cf0d320d44a51743d3e5ba8a300eb8160f9f5730e6ebcfd8d74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7ad025e35454cf0d320d44a51743d3e5ba8a300eb8160f9f5730e6ebcfd8d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7ad025e35454cf0d320d44a51743d3e5ba8a300eb8160f9f5730e6ebcfd8d74"
    sha256 cellar: :any_skip_relocation, sonoma:        "57bb7083f2c4df53c8405b4c4119685e387e3bcd7c6d57123f2010d50d0a2b41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90f870678adbc2eb77554f14c026af31be3cab1f80b0141a2ee8e94765c77935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "505b10ebcc58e0cb03243d9e12198179cf179718bbc657d91175f3bd5035c94a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end