class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghfast.top/https://github.com/k1LoW/tbls/archive/refs/tags/v1.87.0.tar.gz"
  sha256 "8b633dd4165273ec2c3a1f31626727e46aedb19ed44a2aac765fd79849d6ecf1"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "097fd3ac76e24c81ee0dfb1ca25f79f8e3e9caa43caf32349daf4aa2b1ba671b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "937c920099b2ab6d2e925030cbf80af298d2fb202ac62b8f940a534361d70f15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95ab2eb70aa98193dbb71d1a105b60c4c813a36cd2647a015df93d5f7c456b2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d13efa0f5fccefc54cafb1642c7b3936153621a373608ca5c98781ad7aad7642"
    sha256 cellar: :any_skip_relocation, ventura:       "802b2422ffda19590aa5fbf2ed7e7e8ef4377297cca727d487f2979d2cdf51f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1421909912c5941357799f0ef8bc04161999346a37df1daef69b95ab0014432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2647ddf5318660b8d3651950c7042ec2dd5dd738914dc49494a70eb7eec10d0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end