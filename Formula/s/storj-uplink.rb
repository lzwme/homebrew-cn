class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https:storj.io"
  url "https:github.comstorjstorjarchiverefstagsv1.114.3.tar.gz"
  sha256 "93986e29efb8590b8a2085aec797cc9b88a7324e41170c8185e031d61041731f"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy ifwhen
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b990a713bd148d259b4ce0437cd0e844b0bffea280bac10920f98fbc4a0ac68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b990a713bd148d259b4ce0437cd0e844b0bffea280bac10920f98fbc4a0ac68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b990a713bd148d259b4ce0437cd0e844b0bffea280bac10920f98fbc4a0ac68"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8872287823fb5e8c61d3af2347646dbe1813cca7a03f28dd31a57debc35b27a"
    sha256 cellar: :any_skip_relocation, ventura:       "e8872287823fb5e8c61d3af2347646dbe1813cca7a03f28dd31a57debc35b27a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b30e0d00808d4d10fa4f82ddde65599106feeac72fb69b44b22f27a5a0ecfe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"uplink"), ".cmduplink"
  end

  test do
    (testpath"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}uplink ls 2>&1", 1)
  end
end