class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://ghfast.top/https://github.com/prest/prest/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "452c3ad3694108a71a393d9b80d9adf2279b58d38aad1b79201cf243a672e873"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d2cfefc41a52cf976c67736bc6aeb722983cfd38d27dfe80771f6f9cc95bdd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f5cf86216be92566d3a6c643396734b0ebe1ea45367ddfd6e905d95067e6a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3711e454fb380c74a2dfbcdc1a1a99bbab16c6f0f0d13579bdeed8c3893640"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf54910447ca49a15e74f770b0dd6098fcc656a2e59c6192daf2898a7fef0e18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "992f1be6e4ebee24474c788ac72d5cb81a6ddf49af8ce95eb62017d008ec249d"
    sha256 cellar: :any,                 x86_64_linux:  "b64e3b46bba163194fa0843cd11402ca963852e9b1355cfb229891f4fe83800a"
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