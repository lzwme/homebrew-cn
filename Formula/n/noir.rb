class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://owasp.org/www-project-noir/"
  url "https://ghfast.top/https://github.com/owasp-noir/noir/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "ac82e4b59e2d1587ab9ad18286b1b1c55ce6bded9c33e70dd1dfa1b5c8460972"
  license "MIT"
  head "https://github.com/owasp-noir/noir.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "099b7ae4140ed6335c4fdc480c5b610d3e337693853e903142928d7bccc26d06"
    sha256 cellar: :any,                 arm64_sonoma:  "eb5908154fcc779c3853b6a32c1acd46e9e323835f9fbd91d9dc37b85e9c94fe"
    sha256 cellar: :any,                 arm64_ventura: "a602978b91f7e2d5061e4bd13cf90719c31f1c74e39d3685e7530ff4318a36b6"
    sha256 cellar: :any,                 sonoma:        "310710fc173aefefc54a68fe0af1730d9b8170450ef69add4dbd61a4858c0c42"
    sha256 cellar: :any,                 ventura:       "3224e2dd606a851c3ec863b6cf70e2f58c342228cc030e2c9d47245028de0e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7270c1a1ee8dc2888c0efaf4db42f024f568a49ff04d6eafb3a01b26116d657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d8138ce56d8ac4dadbf7f519f83cf58b8705efb4f5a11910d03f1d1833b560"
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