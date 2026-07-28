class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghfast.top/https://github.com/prest/prest/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "0aa188b5a5e739fc3f62a038c8157822fd6bcefc87330fc21d1a56aa3e941e89"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d61e39e315eecd7685252b7799a06c5b902b5738e9b3b7ebb55c094e5b33862b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46e92f7ec7d7c6dea91ff645900bb91d9607f99de178f7108f35b53e45875cd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49147e9377517b8cb857239049df9dec6426de50924a8389959ec25653925999"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ee92ed28a5e9c2deb8f718db2499b2b4a557f5ab167376be5233ed35218b4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16707ce007bad06fb3cbca5146c5cf1a642c9d0144323ceb75361f26752a18bb"
    sha256 cellar: :any,                 x86_64_linux:  "38aae1192f6535a2b9d66898a7783571ba0473739f06cd68c48b33892469fdca"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/prest/prest/v#{version.major}/helpers.PrestVersionNumber=#{version}"
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