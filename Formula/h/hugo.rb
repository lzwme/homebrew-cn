class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.153.2.tar.gz"
  sha256 "e0afb51d479cd4edcc4c775b858d36ffbba1f66ae6e288e0fd0fe2b4eb3d0f10"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91f421cf2c685780327cf9b3aaeab0de14aa53dc043ff722b077dc5f108aa309"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5330ef2318065e5ca54cb608702322966bff5444b5302064faa0e9e078082f4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f5a16c03aa43ff748b721d06f4c32fff573ed58792f1523b651cc1af8e424a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "55de4016f42ae3c73db2647503128005ff3cbc0c34f0c817ad30c75151673d7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16a2519e4cd56cc1e49278443a86bab24612db62646836f8d599d4867b4ba87a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48faea1247cd8edd2cdbcc3a00b89a7bb26b8c124efe72d5e9217f419efb4dd6"
  end

  depends_on "go" => :build

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=#{tap.user}
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", shell_parameter_format: :cobra)
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end