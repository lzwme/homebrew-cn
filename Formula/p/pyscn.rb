class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://github.com/ludo-technologies/pyscn"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "57affd37c7046a0d4e095a8e7f997afad513f07497e8054d180bf26d537e8c47"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17d26e1eaa2e0ff3c2bb899cd3823d4d68cf0329214aac92211d92491dafa46e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d89bb380d7b03a3eae559ff35066085b3e512cb372f9e101c2982f3bfd3da8c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51551774f1a16f849561ac65152c57945a425ecdf7724f671f4dafab38e6298a"
    sha256 cellar: :any_skip_relocation, sonoma:        "75c91d1ca24af5321bbc1700b5c5977e18ac3216d604fcf80a11181a15f4c5b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9a3102f165fdd1c04e2259d4b86f865d7a2e0759811a7bdf3c8c05d50f84cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e7b8ac47704d05ee6c769aea3c38d6cca6fd0d3a3ee88761327bfc714e7017c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
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