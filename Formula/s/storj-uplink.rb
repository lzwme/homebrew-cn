class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://ghfast.top/https://github.com/storj/storj/archive/refs/tags/v1.148.3.tar.gz"
  sha256 "2f7b9296268bb025e64db97c67656d9da4aa451a02cc53a77209defdb7bd6e1b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28770c317e3a8237dd6cc9901778e36ca87a652a1af341bbe37acd9c9630b494"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28770c317e3a8237dd6cc9901778e36ca87a652a1af341bbe37acd9c9630b494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28770c317e3a8237dd6cc9901778e36ca87a652a1af341bbe37acd9c9630b494"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9d245f82e6b03e89c33412051a2bb2a638dbbee60ff4cb0b52549451df0e969"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e13b79b64a5dc5a9e7109f72ce2379a9d2dece914a49bfa71a41d2172654f38f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22be57fb86d81e1f7054eb8cef09c5639f53c3406753ea3cecbca526a4932ab2"
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