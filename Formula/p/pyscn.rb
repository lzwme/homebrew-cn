class Pyscn < Formula
  desc "Intelligent Python Code Quality Analyzer"
  homepage "https://ludo-technologies.github.io/pyscn/"
  url "https://ghfast.top/https://github.com/ludo-technologies/pyscn/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "bdf0021b5453c392770fbe0277a88ab253bc181e8a381672ddf0fead412d3fea"
  license "MIT"
  head "https://github.com/ludo-technologies/pyscn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0359b8f5aa9e3b192c7ea0282470ba396954e9891815968ccc2b64be20b18599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b20b93c5ccfa77877057b9c87c4e797b1786bacd799ce8250075bdf97fd8987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc790fcff5e6f1453a201b6e7fb2ef5d084a9130d85eb92d36dd392ef45975ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f9fc087c0ddb60e22fc9a4623c9af00176622a0571d43b03eb563da401082df"
    sha256 cellar: :any,                 arm64_linux:   "35bcc8318548075e062f9dc1388ecef25c6b858a6e26a28408657d7bf29a08a8"
    sha256 cellar: :any,                 x86_64_linux:  "0e929be07a2ef2273aedae5d8113c9a88310ad396f01f9ac2d7120afedf0190f"
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