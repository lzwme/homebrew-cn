class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.47.2.tar.gz"
  sha256 "0103b2a7dc2ece2cc580b995360cb9773f3c959026bb91c9c678ccc3a4d71bd8"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf9ab1d6fcbcff18c7a89a7cbb6e1e4c1f74c63169979e9a540217763e38d854"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b98c19051198c18d68042cfe6d0351b9e0cbb75616453b73e6d5e56bf2790166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c5871cc2b7f0779133c5a82705674ecbd8e3eae855048256b5a8805df49280d"
    sha256 cellar: :any_skip_relocation, sonoma:        "df47ad92da057bcf55d5da5c21bf4624141256ac3ff706532b74d2d0aa1c724a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bad158d989c3133216a9e8b938655f1298e0b8c00e99ca2052395567c900354"
    sha256 cellar: :any,                 x86_64_linux:  "5699e3b8743236bf0d331275bd1f997d7649ce293fe48c5035e7c9451ed93061"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end