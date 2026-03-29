class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://ghfast.top/https://github.com/owasp-noir/noir/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "fd82153f00997035d3ebc5f9e6429383c1a93b045a10ea87c9eebb0041cb9967"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "af5fd34ce95bb6e743068a19d26812fe1a12eb6b721f4fbfa568ed49c94e8268"
    sha256 cellar: :any,                 arm64_sequoia: "de05960dfac575df0bc685153770968881079eca7eb41c4da10f70db9f98fa2c"
    sha256 cellar: :any,                 arm64_sonoma:  "287fdd4563c09d54836cbeb7d8dabb67284c6b176d497b36d42a050113989650"
    sha256 cellar: :any,                 sonoma:        "1cb66106c2d9d306c71ff3bdc1b9fc6c94edddd9096b6f6ed05de78d8915a6f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ee2744b843b839f2c23a0a69e3183d84f88ea0bfdce196ba060639477bd97c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe57ede7945b19014e9bc7bf6f00b6a50d97d3c2d7bb1610f8cd5ad2bc9ce4f4"
  end

  depends_on "crystal" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

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

    output = shell_output("#{bin}/noir --no-color --base-path . 2>&1")
    assert_match "Generating Report.", output
    assert_match "GET /hello", output
  end
end