class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.152.0.tar.gz"
  sha256 "97adda844380252ff9f0370c733eab5d908d4de0161cf78b7f5f7f677dadf79b"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff5b2a526e8818c9d94d287bc87f0d97e47871283bd5e3afde53ab7a9a787fdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4613eba4d6abc2717fb63e249ce2aafefad6a87c03fd4f554c4bca4b23947df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1df5844a17bb31bbb5d612a10c695dcc7f58485dbf537a1f44970e2aa28dc575"
    sha256 cellar: :any_skip_relocation, sonoma:        "f77dfea8d3f56c6b23feee8eb0ba1b094ac3e70bedcd300a3c78b15d55b3887a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80116ce21a393853c1aa2ab1651714a34bd167392215d5b10b7a4e68ea6a292b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdae710ad287219e56a153001727ae911aa36b999e8e86045097f6547e5bbcb8"
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