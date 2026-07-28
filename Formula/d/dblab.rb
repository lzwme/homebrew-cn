class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://ghfast.top/https://github.com/danvergara/dblab/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "8ba090a100939eaeac06fcb418d0ab72d305d8432e2e6f16bae0ac175a331f40"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27a33b1174ba855765f8b5b4deede64c63560993c859fcb1770abc62c7ba6f90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce5718ecba4634d753c0a53e067938d2da3f3e0663e73886ba9cd209d8133aa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa726b14284aea2dd15b1bc47286c892ec2599e7a19366feb2f7038c82ec0717"
    sha256 cellar: :any_skip_relocation, sonoma:        "36ecf2697797af90fd7f9f00d85e00c60dbc6c54e80a563ef58bd585c83bb686"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f37348e5c631b3b73a1fa8081772ab2db16fdd3293f89ff43eb4d94b7b7ccc05"
    sha256 cellar: :any,                 x86_64_linux:  "d17f9331e1c66e7c684390ac47e43ac51a99dc09e4bab0fd33901e17addeefb2"
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