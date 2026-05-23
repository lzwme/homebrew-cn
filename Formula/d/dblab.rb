class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "813f88bd0c11778d6dcd3c3ca5a962c12960f6dcf4122a82478b95cc8d98a8ba"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7dbb0b82e567ec74c724de12be871e7c2ab539f588c1478f1d7a0b3fcc34bb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b02e2f5e0b7e4d16b473654bbaee10424f7807bf0d9994cf7cb8160726c3f1e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fad5c1ebabc9fd064376674b8b2fcfb8ea64e7c5b6bc87c34d43a770f3345500"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d3aeb2b8a3a4788edea14e2fcdb626d4f976ddc8eb0444bca4600dfd5fcd069"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e18b018707166409ea8fce79f579b70da4460bffb71777f7bd311255e4ed69b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90c988c94908761be10ee0509fc618e767bf64adb2c5d0a4d05fa329afa3913a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end