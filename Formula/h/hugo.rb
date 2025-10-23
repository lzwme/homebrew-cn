class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.152.1.tar.gz"
  sha256 "f58ebd93739869d9475ae219fbafd1991237a4267f7de958719e21d309b3b3e3"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7150997616d3b23f0f6e536fc0ce1eaff35b5e9398a7f545b660bdd44757790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91708127bfbe0f96e9a945268853c718858688a8f33eff36858968d7d8e9eaba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f53244750583ef673a6a36f9fb5b85038a8184dca34449ccf37f5b75a7f52c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d057c9b28f214914b4f7a081f0ec24c25559e5f245688cfdfa4feeed228e8543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f750986b08da3701e571b20ce20bedfbff306e8f3c94235d6e5923bfee85144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eda742915ed6c6d4755cd531f07900c75b73a00d994c493bb177bf56ce1777a6"
  end

  depends_on "go" => :build

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end