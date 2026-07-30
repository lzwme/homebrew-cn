class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghfast.top/https://github.com/prest/prest/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "46b2642693ac7d1965fbc7a6896f2f6557cf1c1d83ec01e004c6ee5e78b27ed0"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eef872fe3218921ba6483eb6233d091db6f6ff05093e899589436330a529127c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04a24351e849770d962b96b841f0474481d32745c521cadbd7949e67b65326f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d403ad88991d67578dcb2dcf66805757587c42da7cd084e73e945db141508137"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4f3712aa22c26c063bd7a4f1d4039e4f6b718a96e69f50d1f4886618f01e7d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be8bc520d2dd209ff2425851ddc22c0f91e745a133979fe1c1703ec1093901f8"
    sha256 cellar: :any,                 x86_64_linux:  "126256f1aaf686238fd62e0eea4f297c37c6d69b3c7b9fba1b874879014c7607"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/prest/prest/v#{version.major}/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/prestd"

    generate_completions_from_executable(bin/"prestd", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"prest.toml").write <<~TOML
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    TOML

    output = shell_output("#{bin}/prestd migrate up --path .", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/prestd version")
  end
end