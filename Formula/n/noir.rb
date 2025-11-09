class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://ghfast.top/https://github.com/owasp-noir/noir/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "42c6e4d2f658db60512d7591dc8085437ade4360e677067f5870308a0d80394b"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "966915cef70dacceba2b610bcff6c73837a12738d9e4ceb4dd673135e071559f"
    sha256 cellar: :any,                 arm64_sequoia: "7e43b3e9b1bebc68a84cdea79a442ab4f03e1ab0ec8533e88729d907d0021279"
    sha256 cellar: :any,                 arm64_sonoma:  "c640122d2842c5624ad5aca5e0172a9d40549fad3f813e4cb8c40131a0137c09"
    sha256 cellar: :any,                 sonoma:        "9f72e4d10e9c62543fa3af503802f62c1b1e9e76c6bd7b4f09bcc209f30c928f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cacb2549badcde11d43de2f6f9ce4e86ff27da8cbf204d36fc055981cf909cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a48117dfa2011a623d429eead6b3ab8f16a7e757a9252cf721e18b85dcebf35d"
  end

  depends_on "crystal" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    system "shards", "build", "--production", "--release", "--no-debug"
    bin.install "bin/noir"

    generate_completions_from_executable(bin/"noir", "--generate-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    (testpath/"api.py").write <<~PYTHON
      from fastapi import FastAPI

      app = FastAPI()

      @app.get("/hello")
      def hello():
          return {"Hello": "World"}
    PYTHON

    output = shell_output("#{bin}/noir --no-color --base-path . 2>&1")
    assert_match "Generating Report.", output
    assert_match "GET /hello", output
  end
end