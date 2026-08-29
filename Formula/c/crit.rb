class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "716fdf5c1156741401163f1c9bf1f56da933fcfba07f879442ab835695e4794a"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4275aaf86d99957834d89d4a65ab7f5261d879706050e110c5331e308734df97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4275aaf86d99957834d89d4a65ab7f5261d879706050e110c5331e308734df97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4275aaf86d99957834d89d4a65ab7f5261d879706050e110c5331e308734df97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6143071fd41f1f3463d22cf0f0b2d68dfabaf45443a395df2f5cca755692b8dc"
    sha256 cellar: :any,                 x86_64_linux:  "71facd1f15dddf19dfa6cf96b1352aa059976ebd2f63f629a801dd4ee2b044da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    assert_path_exists testpath/"reviews"
  end
end