class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "018a57c155fc55cd79ed1fb07879b1eb4f12b408ab666d96e1e52aaa4a65c449"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a38d55b0f6a00773e1e201473f6593c167897a7eb49782feca06dd26b1f73bf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d970dcbd58e3d714521c4b7dd8207e2736f9e3d144edb637a2ec1c383e9c37a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "924e6e70d46ec80a4a11f605488d01c63de7ce50bf1cd1d273e49bcdde86d097"
    sha256 cellar: :any_skip_relocation, sonoma:        "09bb5a7f8c2bfaae02026ab88fe6b901266aea21b985ea254f3a4dd0403f6c6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fae0d7a7e6c7d5865aa5a5859ac2fc673aa675437103f0917d04425352f9e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9086cad1ab385ba18aed6c14960d1174bdabb07cfd3b9fdf64dd6dc092cdafef"
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