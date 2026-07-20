class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghfast.top/https://github.com/prest/prest/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "0b577346ae1afce144b18ffcb33c78877474b6cdeece1e4848a1d4d9653de35b"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc80ad9969b5f3e06708a857518e2573403e0eb44ee729025678ae4ed66531b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c83d6db4e738a71ba93dca32430f409c4cf1fa5f5ba766dc074dd4bba5dfa735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "378162c3b6d551e8c8972df858fc7452c5bbc95257c08a13dda82ab9d4598a4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7bbe476358617f77298805d7432cd4c9e6765251b949e1ac9465343fe61aedf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "053fed5b1a250757c68913d399d7add9e194158bf0e872fbe7f6fc7c5180137c"
    sha256 cellar: :any,                 x86_64_linux:  "7357a218b66b1506aed7c30653ba15bc921ebdab82e3abd31dc3327e4ee56e80"
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