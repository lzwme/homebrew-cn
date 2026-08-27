class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://ghfast.top/https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "ffcdbaa22f4590167fffaba6c7a177e108e719e614e306a58f1393e227f85e3f"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "759187c7ec9d9d78b904dc42c2a975754ee00c371ea44861621d95a3bd2ffc3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caa3f507fd29ee6b47784349c5ca0a8fad5404f01fdc79431eb2be2bef754701"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2a182876d7d6ab3d9396136dbc03cbbcfe685b2ac7011afd3bb7f3495ec3460"
    sha256 cellar: :any_skip_relocation, sonoma:        "e65fec4f854e285c980df96abec3ad5fc69ccc58677c8f27c852de63981bcbda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6818d79dd937937207f1d57630b975ad265c39f09f516b5d9acebc0888271ea"
    sha256 cellar: :any,                 x86_64_linux:  "e6906e22dd1dbc524d9949500c192be2767d8675cff198e72be7a43b08f9d7d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end