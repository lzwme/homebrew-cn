class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://ghfast.top/https://github.com/kriuchkov/tock/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "99d6292d12bda04dbcb43d35455ba56e233cac1921792ff68a4ca3b9bfe9734c"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "470fc91bb5bdd2433a81ce86dab5e80c6baa7aed38a5ca7571cc604ed03a338c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35744982d8be71ea9ac60968ed078e1428a2d368aabc2f8992eab3cf4c587105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce21abdf0ae42ad61f63afdf56c6edfb0646ee867139a4ff2882bb1777752f96"
    sha256 cellar: :any_skip_relocation, sonoma:        "adc8d98aa6eb06ad164175c4344b38d02109dbd924965f4b33f93a6151c75b30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a98d637d05893dce6b6351fce0a48186d077d75bea9376d271ac70e3b8d7b38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "637b0c07e0efd641b27658d4db517bf0eafaffe43c2c1147b3ec343d31a579a9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end