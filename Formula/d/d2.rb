class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://ghproxy.com/https://github.com/terrastruct/d2/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "a6de0a9b99fd77176fb62bba095f6320b7fdd96928326a84516206561744062c"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2964b2cb9d7849ef072048c785a6245049297c41c910ead47a7b43301a09861"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feb3ef7ab6feb895633b70013d721ac50fb6dc157f13e1319aa2dc1cb8fbee46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40e79a18d4f191e18a67c1cd9fefa634dbec0a1856218d2eae51fa39e676b396"
    sha256 cellar: :any_skip_relocation, sonoma:         "9585665ddb99b84ce69395fa4574c951018b75d10484362c56b896aac8b0491d"
    sha256 cellar: :any_skip_relocation, ventura:        "700bd4d42f912744a990262756e081f0acf75598734084d9893ef6e73a4e77c4"
    sha256 cellar: :any_skip_relocation, monterey:       "0c28b62d08adf49de57cf8043b08207259bcc707f4b48f8af476cb65c122a1d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155ff9c2b9f14487a6081148cedc6e72488612a6bb719fa092d2028eca260c6d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", "test.d2"
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end