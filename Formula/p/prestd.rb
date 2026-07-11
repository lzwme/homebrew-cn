class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghfast.top/https://github.com/prest/prest/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "4c6f2b283a3853888e6c19761723637d291d99bd4e157a51b01829ecd0867e61"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86277debd04f8099e9874bb19ee8225e57f0792c62ea1193be110df56cb2bbd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "829bebf12c7a8151f07ebe0b135bcfdec88a785a7c067cddc3b1b0ca91f8625c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f390cad201eb80ee6744d8663b7267bfd2d042141c83782935f62eb034fe5dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "90c0dc1ab81be5ff53e88142567ea5c0f0fc30d8966db45f83ac14b93ef87d46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db137f66947890916561ca38cd61b6aa66d23817cc564cfbfccf3c782090f2be"
    sha256 cellar: :any,                 x86_64_linux:  "0fa285972dd10bd5089b859257c48642146d1d19c824108c9b8fc165140ed5cb"
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