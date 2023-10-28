class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "5d00ac69732998325d05df6241c3d4ab6b6ca64daeaed701cec9e4b716ab4500"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee79262d2e8f27075cdb13ce9d9e3c0050cfc086a3ebc8f606de0efaa69d8369"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e07f1886c684fdb1c3475283344e059dfcfc159f19e19a3d7d292b8f8fada325"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae10dec1c32b349e3a7688f5169191ce34a4989eba9a7fdf1455fbb3fb129711"
    sha256 cellar: :any_skip_relocation, sonoma:         "6071c26a9893435b3d9f80f8653ab78f1b9228b011f71cbcc86e9ff50ea51e22"
    sha256 cellar: :any_skip_relocation, ventura:        "0ca2cfd7686d9215bbad2ddecd81100a7327c6cfb912d17954e51de460ab2a15"
    sha256 cellar: :any_skip_relocation, monterey:       "e98bfac39ed7aeb5c14a70aeeff857036ee12c1a1942fdf82e784442ad1d8909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4276e12d778bf065f0c91871c2ea23b99d41a0296558a3310b42c9031de1b387"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end