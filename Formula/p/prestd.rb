class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghfast.top/https://github.com/prest/prest/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "9e6be2245817749b9d0749ec0ec6e39e58073834e9f319a27fa1d64c0c59e870"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a8625f33c88c7323ebf7fd8a26d93e0949bd2165dafb68b3e4a68f3e0a131af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe173bf7e2f4a2509460fc56cfbcdce93221b10fb9a7c3ab96b71391cf616fd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78c59bfd590e79e59577a15b636e6edeb1c7d7b77b5dccfdbe0016f41a680197"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0b7eb9df5c294232f68d528f4d5e1a8df0d4400f2e8c4c993bbe1c4225374503"
    sha256 cellar: :any,                 x86_64_linux:      "c492497ca8b43d0840e8ab6043e63110432fca7729b2724b72377ca574faa923"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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