class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "5dfbac870b92817022d746fd9f200b48c066f3420899691b8b9fb90060e80838"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3ad812678f8216bbbe995cc682140b825c095b7e6159ef4a0aa95faa11a8fe8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ff7ce9f15e05513bf85812be1fd315caa898bb3e3c1b03164243b478cfaa46b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8abe8dce3f898bad2ac8eeb2da146fb22ce6ad6a4b534535d27cb58270ad0eb"
    sha256 cellar: :any,                 arm64_linux:   "6a430a3c81ee0d4f0b211b06f6fd5ddcbb91bf685ef5adfb0950478f20212e3b"
    sha256 cellar: :any,                 x86_64_linux:  "fb2bfac5f6c892cf6ba9071fd92f1424779e30ffcf94c43d317cef521137bad2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -X github.com/ludo-technologies/pyscn/internal/version.Version=#{version}
      -X github.com/ludo-technologies/pyscn/internal/version.Commit=#{tap.user}
      -X github.com/ludo-technologies/pyscn/internal/version.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pyscn"

    generate_completions_from_executable(bin/"pyscn", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pyscn version")

    (testpath/"test.py").write <<~PY
      def add(a, b):
          return a + b

      print(add(2, 3))
    PY

    output = shell_output("#{bin}/pyscn analyze #{testpath}/test.py 2>&1")
    assert_match "Health Score: 97/100 (Grade: A)", output
  end
end