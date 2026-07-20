class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://ghfast.top/https://github.com/owasp-noir/noir/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "84178c9b50a20b6177198a0d8c7b97853212469e1561bae0d187b68f1e2587a9"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f6c04882495ffe197297d89dc89ecc0bbef94908c7e24631fda56ad71c136bfb"
    sha256 cellar: :any, arm64_sequoia: "ff998bbd578c0b3de34ab93c90267247dd79529eaa02ba3f7a14546bc82ec6e9"
    sha256 cellar: :any, arm64_sonoma:  "60cb361c9579e4e0173223e4f4ee71186358f0a15ddf7fde282cff91a20faff3"
    sha256 cellar: :any, sonoma:        "9ebe4c158a6f19f93d947b2e3402d2e446f6e5ca1bfd0456e7d714f78f5f292a"
    sha256 cellar: :any, arm64_linux:   "429a7500424497446abb5356b08cb5861a53bd44ff18afd893361636c4a6d624"
    sha256 cellar: :any, x86_64_linux:  "5d67e5ff69d0bb5cabc782305a93a01b2324ac09ed3e3bb0cb41dcc806d59044"
  end

  depends_on "crystal" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

    output = shell_output("#{bin}/noir scan --no-color . 2>&1")
    assert_match "Generating Report.", output
    assert_match "GET /hello", output
  end
end