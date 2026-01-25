class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://ghfast.top/https://github.com/owasp-noir/noir/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "da4f9fe2359164edacba9b485efcfe363c2ee00869ede54cb52abc9fe322961f"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "209137cf7aa2c019dad82f2d51f1e436d19d698c2a2bb914ac93b5f31e0d14b3"
    sha256 cellar: :any,                 arm64_sequoia: "8f244e005847d86bac1d035b8fc722f858190454566a60f575f00a244dab463d"
    sha256 cellar: :any,                 arm64_sonoma:  "b77a68237ed95d319f598d7bfa4adc986da30653258d4ec822d2d0db92ed30d0"
    sha256 cellar: :any,                 sonoma:        "19322f12c2730dc668714f67f710abc87bc131fd5c600dc3a902c70e7a6433e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ce99ba2b1735578a0372c310e64f7eef8af9e8d6f426fafb7ce729d354b0889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5920269fae9234e4e8cb0ab1c61f6de5108e812c5b5da2af6c6345389ed96efd"
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